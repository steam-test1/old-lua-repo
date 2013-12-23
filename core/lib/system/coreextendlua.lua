--[[

C o r e E x t e n d L u a
-------------------------

The CoreExtendLua adds functions that will be available in both the
global namespace and the modules namespace. The main difference between
the file CorePatchLua is that this file is required after the module
system is setup. Note that the modules imported here can not rely on
the added 'extra features' being available (catch 22).

]]--

core:module( "CoreExtendLua" )

core:import( 'CoreDebug' )
core:_add_to_pristine_and_global( 'reload_and_compile', CoreDebug.reload_and_compile )
core:_add_to_pristine_and_global( 'out', CoreDebug.out )
core:_add_to_pristine_and_global( 'watch', CoreDebug.watch )
core:_add_to_pristine_and_global( 'cat_print', CoreDebug.cat_print )
core:_add_to_pristine_and_global( 'cat_debug', CoreDebug.cat_debug )
core:_add_to_pristine_and_global( 'cat_error', CoreDebug.cat_error )
core:_add_to_pristine_and_global( 'cat_stack_dump', CoreDebug.cat_stack_dump )
core:_add_to_pristine_and_global( 'cat_print_inspect', CoreDebug.cat_print_inspect )
core:_add_to_pristine_and_global( 'cat_debug_inspect', CoreDebug.cat_debug_inspect )

core:import( 'CoreClass' )
core:_add_to_pristine_and_global( 'class', CoreClass.class )

core:import( 'CoreEvent' )
core:_add_to_pristine_and_global( 'callback', CoreEvent.callback )

core:import( 'CoreCode' )
core:_add_to_pristine_and_global( 'alive', CoreCode.alive )
core:_add_to_pristine_and_global( 'deprecation_warning', CoreCode.deprecation_warning )
core:_add_to_pristine_and_global( 'inspect', CoreCode.inspect )
core:_add_to_pristine_and_global( 'help', CoreCode.help )
core:_add_to_pristine_and_global( 'properties', CoreCode.properties )

core:import( 'CoreLogic' )
core:_add_to_pristine_and_global( 'iff', CoreLogic.iff )
core:_add_to_pristine_and_global( 'toboolean', CoreLogic.toboolean )
