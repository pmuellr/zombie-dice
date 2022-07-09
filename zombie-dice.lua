#!/usr/bin/env lua

local function cloneList(list)
    return { table.unpack(list) }
end

local function toStringList(list)
    local result = ''
    for key, item in pairs(list) do
        result = result .. item.toString() .. ' '
    end
    return string.sub(result, 1, #result - 1)
end

local function Die(color, faces)
    local self = {}
    local topFace = nil

    function self.top() return topFace end
    function self.setTop(face) topFace = face end
    function self.reset() topFace = nil end

    function self.roll()
        topFace = faces[math.random(#faces)]
        return topFace
    end

    function self.toString()
        return color .. (topFace or '')
    end

    return self
end

--[[
    The three types of die, with their face values:
    f: footprints; s: shotgun; b: brains
--]]

local function GreDie() return Die('G', { 'f', 'f', 's', 'b', 'b', 'b' }) end
local function YelDie() return Die('Y', { 'f', 'f', 's', 's', 'b', 'b' }) end
local function RedDie() return Die('R', { 'f', 'f', 's', 's', 's', 'b' }) end

local function getNewDice()
    return {
        GreDie(), GreDie(), GreDie(), GreDie(), GreDie(), GreDie(), -- 6
        YelDie(), YelDie(), YelDie(), YelDie(),                     -- 4
        RedDie(), RedDie(), RedDie()                                -- 3
    }
end

local function takeRandomly(dice, count)
    count = count or 1
    if count > #dice then return nil end

    local remaining = cloneList(dice)
    local taken = {}

    for i = 1, count do
        local index = math.random(#remaining)
        local die = table.remove(remaining, index)
        table.insert(taken, die)
    end

    return taken, remaining
end

local function GameState(playerA, playerB)
    local self = {}

    function self.playerA() return playerA end
    function self.playerB() return playerA end

    function self.toString()
        return playerA.toString() .. '; ' .. playerB.toString()
    end

    function self.winner()
        if playerA.brains() >= 13 then return playerA end
        if playerB.brains() >= 13 then return playerB end
        return nil
    end

    function self.gameOver()
        return self.winner() ~= nil
    end

    return self
end

local function Player(name)
    local self = {}
    local brains = 0

    function self.name() return name end
    function self.brains() return brains end
    function self.addBrains(n) brains = brains + n end

    function self.toString()
        return 'player ' .. name .. ' has ' .. brains .. ' brains'
    end

    return self
end

local function HumanPlayer(name)
    local self = Player(name)

    function self.shouldRollAgain()
        -- prompt user if they want to roll again
        return false
    end

    return self
end

local function CompuPlayer(name)
    local self = Player(name)

    function self.shouldRollAgain()
        -- compute if we should roll again
        return false
    end

    return self
end

local function Turn(player)
    local self = {}

    ---@type table | nil
    local diceInCup = getNewDice()
    ---@type table | nil
    local dicePicked = {}
    local shotguns = {}
    local brains = {}
    local feet = {}

    function self.pickDiceFromCup(count)
        dicePicked, diceInCup = takeRandomly(diceInCup, count)
    end

    function self.rollPickedDice()
        for key, die in next, dicePicked do
            local roll = die.roll()
        end
    end

    function self.moveRolledDice()
        for key, die in pairs(dicePicked) do
            local face = die.top()
            if face == 'f' then
                table.insert(feet, die)
            elseif face == 's' then
                table.insert(shotguns, die)
            elseif face == 'b' then
                table.insert(brains, die)
            end
        end
    end

    print('\nstarting a new turn for ' .. player.name())
    for key, die in pairs(diceInCup) do die.reset() end

    self.pickDiceFromCup(3)
    print('dice picked from cup: ' .. toStringList(dicePicked))
    print('dice still in cup:    ' .. toStringList(diceInCup))

    self.rollPickedDice()
    print('dice rolled: ' .. toStringList(dicePicked))

    self.moveRolledDice()

    print('feet:     ' .. toStringList(feet))
    print('shotguns: ' .. toStringList(shotguns))
    print('brains:   ' .. toStringList(brains))

    return self
end

local function printGameState(gameState)
    print(gameState.toString())
    if gameState.gameOver() then 
        print('  winner: ' .. gameState.winner().name())
    else
        print('  no winner yet')
    end
end

print("Welcome to Zombie Dice")
print("   http://www.sjgames.com/dice/zombiedice/")

local playerA = HumanPlayer('jim')
local playerB = CompuPlayer('bob')
local gameState = GameState(playerA, playerB)


print('\ngame state:')
printGameState(gameState)
playerB.addBrains(42)
printGameState(gameState)

print('\ndie rolls:')
local gDie = GreDie()
local yDie = YelDie()
local rDie = RedDie()

for count = 1, 10 do
    local gRoll = gDie.roll()
    local yRoll = yDie.roll()
    local rRoll = rDie.roll()
    print('G: ' .. gRoll .. '  Y: ' .. yRoll .. '  R: ' .. rRoll)
end

print('\nturns:')
for count = 1, 10 do
    Turn(playerA)
end
