--=========== Copyright © 2017, Planimeter, All rights reserved. =============--
--
-- Purpose:
--
--============================================================================--

local kazmath = require( "kazmath" )
local ffi     = require( "ffi" )
local GL      = require( "opengl" )

local framework = framework
local table     = table

module( "framework.graphics" )

local mat4 = ffi.new( "kmMat4" )
kazmath.kmMat4Identity( mat4 )
state = state or { mat4 }

function getTransform()
	return state[ #state ]
end

function push()
	local top = ffi.new( "kmMat4" )
	kazmath.kmMat4Assign( top, getTransform() )
	table.insert( state, top )
end

function pop()
	if ( #state == 1 ) then return end
	table.remove( state, #state )
end

function origin()
	kazmath.kmMat4Identity( getTransform() )
end

function rotate( angle )
	local rotation = ffi.new( "kmMat4" )
	kazmath.kmMat4RotationZ( rotation, angle )
	kazmath.kmMat4Multiply( getTransform(), getTransform(), rotation )
end

function scale( x, y, z )
	z = z or 1
	local scaling = ffi.new( "kmMat4" )
	kazmath.kmMat4Scaling( scaling, x, y, z )
	kazmath.kmMat4Multiply( getTransform(), getTransform(), scaling )
end

function translate( x, y, z )
	z = z or 0
	local translation = ffi.new( "kmMat4" )
	kazmath.kmMat4Translation( translation, x, y, z )
	kazmath.kmMat4Multiply( getTransform(), getTransform(), translation )
end

function updateTransform()
	local model = GL.glGetUniformLocation( shader, "model" )
	GL.glUniformMatrix4fv( model, 1, GL.GL_FALSE, getTransform().mat )
end
