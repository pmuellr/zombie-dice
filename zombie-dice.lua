#!/usr/bin/env lua

--[[
    The three types of die, with their face values:
    - f: footprints
    - s: shotgun
    - b: brains
--]]

local gDie = 'ffsbbb'
local yDie = 'ffssbb'
local rDie = 'ffsssb'

local dice = { 
    gDie, gDie, gDie, gDie, gDie, gDie, -- 6
    yDie, yDie, yDie, yDie,             -- 4
    rDie, rDie, rDie                    -- 3
}

print("Welcome to Zombie Dice")
print("   http://www.sjgames.com/dice/zombiedice/")



function rollDice()
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

    return self
end

local function CompuPlayer(name)
    local self = Player(name)
    
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

