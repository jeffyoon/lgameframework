--=========== Copyright © 2017, Planimeter, All rights reserved. =============--
--
-- Purpose:
--
--============================================================================--

require( "framework.graphics.font" )
require( "framework.graphics.image" )
require( "framework.graphics.opengl" )
require( "framework.graphics.primitive" )
require( "framework.graphics.shader" )
require( "framework.graphics.transformation" )

local GL  = require( "opengl" )
local ffi = require( "ffi" )
local SDL = require( "sdl" )

local framework = framework
local tostring  = tostring

module( "framework.graphics" )

function clear()
	GL.glClear( GL.GL_COLOR_BUFFER_BIT )
end

function draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
	x = x or 0
	y = y or 0
	drawable:draw( x, y, r, sx, sy, ox, oy, kx, ky )
end

function getColor()
	return color
end

function getFont()
	return _font
end

function getSize()
	local width  = ffi.new( "int[1]" )
	local height = ffi.new( "int[1]" )
	SDL.SDL_GL_GetDrawableSize( framework.window.window, width, height )
	return width[0], height[0]
end

function newFont( filename, size )
	local font = framework.graphics.font
	return font( filename, size )
end

function newImage( filename )
	local image = framework.graphics.image
	return image( filename )
end

function newModel( filename )
	local model = framework.graphics.model
	return model( filename )
end

function print( text, x, y, r, sx, sy, ox, oy, kx, ky )
	text = tostring( text )
	x = x or 0
	y = y or 0
	getFont():print( text, x, y, r, sx, sy, ox, oy, kx, ky )
end

function setColor( color )
	color[ 1 ] = ( color[ 1 ] or 0 ) / 255
	color[ 2 ] = ( color[ 2 ] or 0 ) / 255
	color[ 3 ] = ( color[ 3 ] or 0 ) / 255

	local pColor = ffi.new( "GLfloat[4]", color )
	local shader = framework.graphics.getShader()
	local index  = GL.glGetUniformLocation( shader, "color" )
	GL.glUniform4fv( index, 1, pColor )
	_M.color = color
end

function setFont( font )
	_font = font
end

function setVSync( vsync )
	SDL.SDL_GL_SetSwapInterval( vsync and 1 or 0 )
end
