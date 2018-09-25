local GRID_WIDTH = 8
local GRID_HEIGHT = 8
local CELL_WIDTH = 40
local CELL_HEIGHT = 40
--
-- Create a 2D array to hold our objects.
local grid = {}
for i = 1, GRID_HEIGHT do
	grid[i] = {}
end

--
-- load the background image:

local checkerBoard = display.newImageRect("table.png", 320, 320)
checkerBoard.x = display.contentCenterX
checkerBoard.y = display.contentCenterY

--
-- Calculate some values
--
local gbOffsetX = checkerBoard.x - ( checkerBoard.width * checkerBoard.anchorX ) 
local gbOffsetY = checkerBoard.y - ( checkerBoard.height * checkerBoard.anchorY )

--
-- Using positions 1, 8 for X and Y, draw the object at the right place in the grid
--

local function spawnPiece( xPos, yPos, pieceType )
	if pieceType ~= "red" and pieceType ~= "white" then
		print( "Invalid piece type", pieceType )
		return nil
	end
	if xPos < 1 or xPos > GRID_WIDTH or yPos < 1 or yPos > GRID_HEIGHT then
		print( "Position out of range:", xPos, yPos )
		return nil
	end

	local piece = display.newImageRect( "token_" .. pieceType .. ".png", CELL_WIDTH, CELL_HEIGHT )
	--
	-- record the pieces logical position on the board
	--
	piece.xPos = xPos
	piece.yPos = yPos
	--
	-- Position the piece
	--
	piece.x = (xPos - 1) * CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX
	piece.y = (yPos - 1) * CELL_HEIGHT + (CELL_HEIGHT * 0.5) + gbOffsetY

	return piece
end

local function movePiece(piece, xPos, yPos )
	-- check to see if the position is occupied.  You can do either:
	-- 1. "Capture the piece".  This would involve removeing the piece 
	--    that is there before moving to the spot or
	-- 2. "Reject the move" because the spot is occupied.  For the purpose
	--    of this tutorial we will reject the move.
	--
	if xPos < 1 or xPos > GRID_WIDTH or yPos < 1 or yPos > GRID_HEIGHT then
		return false
	end
	if grid[yPos][xPos] == nil then -- got an empty spot
		--
		-- get the screen x, y for where we are moving to
		--
		local x = (xPos - 1) * CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX
		local y = (yPos - 1) * CELL_HEIGHT + (CELL_HEIGHT * 0.5) + gbOffsetY
		--
		-- save the old grid x, y
		--
		local oldXPos = piece.xPos
		local oldYPos = piece.yPos
		--
		-- Move the object in the table
		--
		grid[yPos][xPos] = piece
		grid[yPos][xPos].xPos = xPos
		grid[yPos][xPos].yPos = yPos
		grid[oldYPos][oldXPos] = nil
		--
		-- Now move the physical graphic
		--
		transition.to(grid[yPos][xPos], { time = 500, x = x, y = y})
		return true
	end
end

--
-- Generate a few objects
--
--
-- a holding piece for moving the object
--
local lastObject 

for i = 1, 10 do
	local xPos = math.random( 1, GRID_WIDTH )
	local yPos = math.random( 1, GRID_HEIGHT )
	local color = "red"
	if math.random(2) == 2 then
		color = "white"
	end
	grid[yPos][xPos] = spawnPiece(xPos, yPos, color, checkerBoard)
	lastObject = grid[yPos][xPos]
end

timer.performWithDelay(2000, function() movePiece( lastObject, 4, 5); end, 1)