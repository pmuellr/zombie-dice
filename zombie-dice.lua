#!/usr/bin/env lua

--[[
    The three types of die, with their face values:
    - f: footprints
    - s: shotgun
    - b: brains
--]]

local function rollDie(die)
    return die[math.random(#die)]
end

local gDie = { 'f', 'f', 's', 'b', 'b', 'b' }
local yDie = { 'f', 'f', 's', 's', 'b', 'b' }
local rDie = { 'f', 'f', 's', 's', 's', 'b' }

function gDie.roll() return rollDie(gDie) end
function yDie.roll() return rollDie(gDie) end
function rDie.roll() return rollDie(gDie) end

local dice = { 
    gDie, gDie, gDie, gDie, gDie, gDie, -- 6
    yDie, yDie, yDie, yDie,             -- 4
    rDie, rDie, rDie                    -- 3
}

print("Welcome to Zombie Dice")
print("   http://www.sjgames.com/dice/zombiedice/")

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

    function self.rollAgain()
        -- prompt user if they want to roll again
        return false
    end

    return self
end

local function CompuPlayer(name)
    local self = Player(name)

    function self.rollAgain()
        -- compute if we should roll again
        return false
    end

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
local playerA = HumanPlayer('jim')
local playerB = Player('bob')
local gameState = GameState(playerA, playerB)

printGameState(gameState)
playerB.addBrains(42)
printGameState(gameState)

print('die: ' .. gDie.roll())
print('die: ' .. gDie.roll())
print('die: ' .. gDie.roll())
print('die: ' .. gDie.roll())
print('die: ' .. gDie.roll())
print('die: ' .. gDie.roll())
