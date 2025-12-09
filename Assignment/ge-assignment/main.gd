extends Node3D

var xrinterface: XRInterface

func _ready():
	xrinterface = XRServer.find_interface("OpenXr")
	
	if xrinterface and xrinterface.is_initialized():
		print("OpenXR initialized")
		
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
	else:
		print("OpenXR not working")
