---------------------------------------------------------------------------
--- DEVICE ENV
--- used by device_init/sounds_init/clickabledata, mainpanel_init, devices
---
--- also available:
---  io, lfs, log, LockOn_Options, math, os
---------------------------------------------------------------------------

--- when set to true in device init, close lua state after initialization in post_initialize
--- set to false for scripts that keep running (e.g. with update)
need_to_be_closed = true

--- parameter for power bus (without use of avSimpleElectricSystem, set to 1 to power)
power_bus_handle = ""

------------------------------------------------------------------------------
--- Device functions (only available in devices)
------------------------------------------------------------------------------

--- Creates a sound
--- not in mainpanel
--- @param sdef string @refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef
--- @return table
function create_sound(sdef) return end

--- Creates a sound host
--- not in mainpanel
--- @param name string
--- @param type string @"2D", "3D", "HEADPHONES"
--- @param x number
--- @param y number
--- @param z number
--- @return table
function create_sound_host(name, type, x, y, z) return end

--- Returns a device
--- @param id number
--- @return avDevice
function GetDevice(id) return end

--- Returns the current device
--- @return avDevice
function GetSelf() return end

--- Calls update() function within device with given time step
--- not in mainpanel
--- @param time_step number
function make_default_activity(time_step) end

function SetGlobalCommand() end

------------------------------------------------------------------------------
--- MainPanel specific
------------------------------------------------------------------------------

--- Creates a gauge
--- @param type string|nil @nil, "parameter", "cycled" or "external_arg" (see Gauge for usage)
--- @return Gauge
function CreateGauge(type) return end

--- @class Gauge
--- @field arg_number number @argument number to be animated
--- @field input table @input range from controller or parameter, e.g. {0,1}
--- @field output table @output range for argument, e.g. {0,1}
--- @field controller userdata|nil @controller from LoRegisterPanelControls (for type=nil and type="cycled")
--- @field params table|nil @parameters for controller function
--- @field parameter_name string|nil @parameter name (for type="parameter")
--- @field cycle_value number|nil @cycle value (for type="cycled")
--- @field external_arg number|nil @external argument number (for type="external_arg")

--- Returns controllers
--- @return MainPanelControls
function LoRegisterPanelControls() return end

--- @class MainPanelControls
--- @field Panel_Rot_X userdata
--- @field Panel_Shake_Y userdata
--- @field Panel_Shake_Z userdata
--- @field base_gauge_AngleOfAttack userdata
--- @field base_gauge_AngleOfSlide userdata
--- @field base_gauge_BarometricAltitude userdata
--- @field base_gauge_CanopyPos userdata
--- @field base_gauge_CanopyState userdata
--- @field base_gauge_EngineLeftFuelConsumption userdata
--- @field base_gauge_EngineLeftRPM userdata
--- @field base_gauge_EngineLeftTemperatureBeforeTurbine userdata
--- @field base_gauge_EngineRightFuelConsumption userdata
--- @field base_gauge_EngineRightRPM userdata
--- @field base_gauge_EngineRightTemperatureBeforeTurbine userdata
--- @field base_gauge_FlapsPos userdata
--- @field base_gauge_FlapsRetracted userdata
--- @field base_gauge_Heading userdata
--- @field base_gauge_HelicopterCollective userdata
--- @field base_gauge_HelicopterCorrection userdata
--- @field base_gauge_HorizontalAcceleration userdata
--- @field base_gauge_IndicatedAirSpeed userdata
--- @field base_gauge_LandingGearHandlePos userdata
--- @field base_gauge_LateralAcceleration userdata
--- @field base_gauge_LeftMainLandingGearDown userdata
--- @field base_gauge_LeftMainLandingGearUp userdata
--- @field base_gauge_MachNumber userdata
--- @field base_gauge_MagneticHeading userdata
--- @field base_gauge_NoseLandingGearDown userdata
--- @field base_gauge_NoseLandingGearUp userdata
--- @field base_gauge_Pitch userdata
--- @field base_gauge_RadarAltitude userdata
--- @field base_gauge_RateOfPitch userdata
--- @field base_gauge_RateOfRoll userdata
--- @field base_gauge_RateOfYaw userdata
--- @field base_gauge_RightMainLandingGearDown userdata
--- @field base_gauge_RightMainLandingGearUp userdata
--- @field base_gauge_Roll userdata
--- @field base_gauge_RudderPosition userdata
--- @field base_gauge_SpeedBrakePos userdata
--- @field base_gauge_StickPitchPosition userdata
--- @field base_gauge_StickRollPosition userdata
--- @field base_gauge_ThrottleLeftPosition userdata
--- @field base_gauge_ThrottleRightPosition userdata
--- @field base_gauge_TotalFuelWeight userdata
--- @field base_gauge_TrueAirSpeed userdata
--- @field base_gauge_VerticalAcceleration userdata
--- @field base_gauge_VerticalVelocity userdata
--- @field base_gauge_WOW_LeftMainLandingGear userdata
--- @field base_gauge_WOW_NoseLandingGear userdata
--- @field base_gauge_WOW_RightMainLandingGear userdata
--- @field canopy userdata
--- @field day_night_texture_switcher userdata
--- @field head_shift_X userdata
--- @field head_shift_Y userdata
--- @field head_shift_Z userdata
--- @field mirrors_draw userdata
--- @field pilot_draw userdata

--- ?
gaugemeta = {}

------------------------------------------------------------------------------
--- Functions available in device and indicator env
------------------------------------------------------------------------------

function a_cockpit_highlight(id, name, size, plugin) end
function a_cockpit_highlight_indication(id, indicator, name, size, plugin) end
function a_cockpit_highlight_position(id, x, y, z, dimX, dimY, dimZ) end
function a_cockpit_lock_player_seat(number) end
function a_cockpit_param_save_as(source, destination) end
function a_cockpit_perform_clickable_action(device, command, value, plugin) end
function a_cockpit_pop_actor() end
function a_cockpit_push_actor(number) end
function a_cockpit_remove_highlight(id) end
function a_cockpit_unlock_player_seat() end
function a_start_listen_command(command, flag, count, min, max, device) end
function a_start_listen_event(event, flag) end
function c_argument_in_range(argument, min, max, plugin) end
function c_cockpit_highlight_visible(id) end
function c_cockpit_param_equal_to(param, value) end
function c_cockpit_param_in_range(param, min, max) end
function c_cockpit_param_is_equal_to_another(param1, param2) end
function c_indication_txt_equal_to(id, name, value) end
function c_start_wait_for_user(flagCont, flagBack) end
function c_stop_wait_for_user() end
function copy_to_mission_and_dofile() end
function copy_to_mission_and_get_buffer() end
function dbg_print() end

--- Triggers command with value. Similar to avDevice:performClickableAction() but doesn't move the switch.
--- If sending a command to a device you do not own, you MUST pass a number to device_id.
--- If the command is being listened for, the exact number will not matter.
--- @param device_id number|nil
--- @param command number
--- @param value number
function dispatch_action(device_id, command, value) end

--- Loads mission file
--- @param file string
function do_mission_file(file) end

--- Finds viewport by name
--- @param name string
--- @return table
function find_viewport(name) return end

--- Converts lat/lon to local coordinates
--- @param lat number
--- @param lon number
--- @return vec3
function geo_to_lo_coords(lat, lon) return end

--- Returns time of day in seconds (including fractional seconds)
--- @return number
function get_absolute_model_time() return end

--- Returns aircraft draw argument value
--- @param arg number
--- @return number
function get_aircraft_draw_argument_value(arg) return end

--- Returns aircraft mission data
--- @param key string @e.g. "Radio"
--- @return table
function get_aircraft_mission_data(key) return end

--- Returns aircraft property
--- @param name string
--- @return any
function get_aircraft_property(name) end

--- Returns aircraft property or nil
--- @param name string
--- @return any
function get_aircraft_property_or_nil(name) end

--- Returns aircraft type
--- @return string
function get_aircraft_type() return end

--- Returns sensor base data
--- @return BaseData
function get_base_data() return end

--- Returns clickable element reference
--- @param point_name string @see point name in clickabledata.lua, index of elements
--- @return table @functions: set_hint, update, hide
function get_clickable_element_reference(point_name) return end

--- Returns cockpit draw argument value
--- @param arg number
--- @return number
function get_cockpit_draw_argument_value(arg) return end

--- Returns path for plugin
--- @param name string @plugin name
--- @return string
function get_dcs_plugin_path(name) return end

--- ??
function get_input_devices() end

--- Returns mission route
--- @return table @route (table of wps)
function get_mission_route() return end

--- Returns time in seconds since mission launched
--- @return number
function get_model_time() return end

--- Returns multi-monitor preset name
--- @return string
function get_multimonitor_preset_name() return end

--- ??
function get_non_sim_random_evenly() end

--- Returns option value
--- @param option string @option name "difficulty.hideStick"
--- @param env string @"local"
--- @return any
function get_option_value(option, env) end

--- This is used to set a param handle, best described as a global variable. It is useful for setting animations in mainpanel.lua, getting information into indicators, and getting information between an EFM and lua if you have an EFM.
--- @param param string The param handle name
--- @return ParamHandle
function get_param_handle(param) return end

--- ??
function get_player_crew_index() end

--- ??
function get_plugin_option() end

--- Returns plugin option value
--- @param plugin string @plugin name
--- @param option string @option name
--- @param env string @"local"
function get_plugin_option_value(plugin, option, env) end

--- ??
function get_random_evenly() end

--- ??
function get_random_orderly() end

--- Returns terrain related data
--- @param file string @"beacons", "beaconsFile", "Airdromes", "name", "TAD_vfs_archives", "TAD_chart_map_set_file", "edterrainVersion", "KNEEBOARD"
--- @return table @terrain related data (display_name, radio={})
function get_terrain_related_data(file) return end

--- Returns UI main view
--- @return number, number, number, number, number @start_x, start_y, main_w, main_h, gui_scale
function get_UIMainView() return end

--- Returns all viewports
--- @return table
function get_Viewports() return end

--- Returns cockpit parameters
--- @return table
function list_cockpit_params() return end

--- Returns list indication
--- @param indicator_id number
--- @return string @indication text
function list_indication(indicator_id) return end

--- Converts local coordinates to lat/lon
--- @param pos vec3
--- @return number, number @lat, lon
function lo_to_geo_coords(pos) return end

--- Loads mission file
--- @param file string @filepath
--- @return function @chunk
function load_mission_file(file) return end

--- Makes a font
--- @param font_data table @{used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}
--- @param rgba table @{0, 255, 0, 255}
--- @return table
function MakeFont(font_data, rgba) return end

--- Makes a material
--- @param texture_path string @material name, path to texture (dds, tga)
--- @param rgba table @{0, 255, 0, 255}
--- @return table
function MakeMaterial(texture_path, rgba) return end

--- Mounts a model path.
--- @param path string The path.
function mount_vfs_model_path(path) return end

--- Mounts a path to a mountpoint
--- @param mount_point string @e.g. "/textures/tad/"
--- @param path string
function mount_vfs_path_to_mount_point(mount_point, path) end

--- Mounts a texture archives path.
--- @param path string The directory path.
function mount_vfs_texture_archives(path) end

--- Mounts a texture path.
--- @param path string The path.
function mount_vfs_texture_path(path) return end

--- Prints a message on screen ingame
--- @param text string
function print_message_to_user(text) end

--- Saves mission (?) file
--- @param file string @filepath
--- @param content string @content
function save_to_mission(file, content) end

--- Sets aircraft draw argument value (equivalent to ed_fm_set_draw_args)
--- @param argument number
--- @param value number
function set_aircraft_draw_argument_value(argument, value) end

--- ??
function set_crew_member_seat_adjustment() end

--- Shows param list
--- @param enable boolean
function show_param_handles_list(enable) end

--- ??
function switch_labels_off() end

--- Checks if track file is reading
--- @return boolean
function track_is_reading() return end

--- Checks if track file is writing
--- @return boolean
function track_is_writing() return end

--- ??
function UTF8_strlen() end

--- ??
function UTF8_substring() end

------------------------------------------------------------------------------
--- avDevice functions
------------------------------------------------------------------------------

--- @class avDevice
--- @field SetCommand fun()
--- @field link any @userdata
--- @field listen_command fun(self:avDevice, command) @listens to command
--- @field listen_event fun(self:avDevice, event) @"setup_HMS", "setup_NVG", "DisableTurboGear", "EnableTurboGear", "GroundPowerOn", "GroundPowerOff", "repair", "WeaponRearmFirstStep", "WeaponRearmComplete", "OnNewNetHelicopter", "initChaffFlarePayload", "switch_datalink", "OnNewNetPlane", "LinkNOPtoNet"
--- @field performClickableAction fun(self:avDevice, command:number, value:number, echo:boolean) @used to perform clickable actions (echo=true to ignore the connected SetCommand)

--- @class avLuaDevice:avDevice
--- @field SetDamage fun()

--- @class avAutostartDevice:avDevice
--- @field check_autostart_condition fun()

--- @class avBaseIKP:avDevice
--- @field get_airspeed_deviation fun()
--- @field get_attitude_warn_flag_val fun()
--- @field get_bank fun()
--- @field get_bank_steering fun()
--- @field get_height_deviation fun()
--- @field get_pitch fun()
--- @field get_pitch_steering fun()
--- @field get_sideslip fun()
--- @field get_steering_warn_flag_val fun()
--- @field get_track_deviation fun()

--- @class avIntercom:avDevice
--- @field easy_comm_override fun()
--- @field get_noise_level fun()
--- @field get_signal_level fun()
--- @field is_communicator_available fun()
--- @field make_setup_for_communicator fun()
--- @field set_communicator fun()

--- @class avIntercomWWII:avIntercom

--- @class avSimpleElectricSystem:avDevice
--- @field AC_Generator_1_on fun(onoff:boolean)
--- @field AC_Generator_2_on fun(onoff:boolean)
--- @field DC_Battery_on fun(onoff:boolean)
--- @field SetDamage fun()
--- @field get_AC_Bus_1_voltage fun():number
--- @field get_AC_Bus_2_voltage fun():number
--- @field get_DC_Bus_1_voltage fun():number
--- @field get_DC_Bus_2_voltage fun():number

--- @class avSimpleRadar:avDevice
--- @field SetDamage fun()
--- @field get_power fun()
--- @field set_power fun()

--- @class avSimpleRWR:avDevice
--- @field SetDamage fun()
--- @field get_power fun()
--- @field reset fun()
--- @field set_power fun()

--- @class avSimpleWeaponSystem:avDevice
--- @field SetDamage fun()
--- @field drop_chaff fun(count:number, dispenser:number) @see chaff_flare_dispenser in aircraft definition
--- @field drop_flare fun(count:number, dispenser:number) @see chaff_flare_dispenser in aircraft definition
--- @field emergency_jettison fun()
--- @field emergency_jettison_rack fun()
--- @field get_ECM_status fun()
--- @field get_chaff_count fun():number @get chaff count
--- @field get_flare_count fun():number @get flare count
--- @field get_station_info fun()
--- @field get_target_range fun()
--- @field get_target_span fun()
--- @field launch_station fun(self:avDevice, station:number) @launch station (weapon system device)
--- @field select_station fun(self:avDevice, station:number) @select station (weapon system device)
--- @field set_ECM_status fun()
--- @field set_target_range fun()
--- @field set_target_span fun()

--- @class avUHF_ARC_164:avDevice
--- @field get_frequency fun()
--- @field get_modulation fun()
--- @field is_frequency_in_range fun()
--- @field is_on fun()
--- @field set_channel fun()
--- @field set_frequency fun()
--- @field set_modulation fun()

--- @class ccMainPanel:avDevice
--- @field get_argument_value fun(self:avDevice, argument) @gets argument value
--- @field get_light_reference fun(self:avDevice)
--- @field set_argument_value fun(self:avDevice, argument, value) @sets argument value
--- @field update_arguments fun(self:avDevice)

--- @class ccIndicator
--- @field add_purpose fun()
--- @field assign_dedicated_viewport fun()
--- @field get_dedicated_viewport fun()
--- @field remove_purpose fun()
--- @field set_page fun()

--- @class ccKneeboard:ccIndicator
--- @field Add_Map_Page fun(page_subset_id:number, script_path:string)

------------------------------------------------------------------------------
--- Param handle
------------------------------------------------------------------------------

--- @class ParamHandle
--- @field get fun(self:ParamHandle):number
--- @field set fun(self:ParamHandle, value:number)

------------------------------------------------------------------------------
--- Base data
------------------------------------------------------------------------------

--- @class BaseData
--- @description device base data
--- @field getAngleOfAttack fun():number Gets the current angle of attack
--- @field getAngleOfSlide fun():number Gets the current angle of slide
--- @field getBarometricAltitude fun(): number Gets the current barometric altitude in meters.
--- @field getCanopyPos fun()
--- @field getCanopyState fun()
--- @field getEngineLeftFuelConsumption fun()
--- @field getEngineLeftRPM fun(): number Gets the current left engine RPM in percent.
--- @field getEngineLeftTemperatureBeforeTurbine fun(): number Gets the current left engine temperature before turbine.
--- @field getEngineRightFuelConsumption fun()
--- @field getEngineRightRPM fun(): number Gets the current right engine RPM in percent.
--- @field getEngineRightTemperatureBeforeTurbine fun(): number Gets the current right engine temperature before turbine.
--- @field getFlapsPos number
--- @field getFlapsRetracted fun()
--- @field getHeading fun(): number Gets the current heading in radians. (?)
--- @field getHelicopterCollective fun()
--- @field getHelicopterCorrection fun()
--- @field getHorizontalAcceleration fun()
--- @field getIndicatedAirSpeed fun(): number Gets the current indicated airspeed in m/s.
--- @field getLandingGearHandlePos fun()
--- @field getLateralAcceleration fun()
--- @field getLeftMainLandingGearDown fun()
--- @field getLeftMainLandingGearUp fun()
--- @field getMachNumber fun(): number Gets the current mach.
--- @field getMagneticHeading fun(): number Gets the current magnetic heading in radians. (?)
--- @field getNoseLandingGearDown fun()
--- @field getNoseLandingGearUp integer
--- @field getPitch fun(): number Gets the current pitch in radians.
--- @field getRadarAltitude fun(): number Gets the current radar altitude in meters.
--- @field getRateOfPitch fun()
--- @field getRateOfRoll fun()
--- @field getRateOfYaw fun()
--- @field getRightMainLandingGearDown fun()
--- @field getRightMainLandingGearUp fun()
--- @field getRoll fun(): number Gets the current roll in radians.
--- @field getRudderPosition fun()
--- @field getSelfAirspeed fun()
--- @field getSelfCoordinates fun()
--- @field getSelfVelocity fun()
--- @field getSpeedBrakePos fun()
--- @field getStickPitchPosition number
--- @field getStickRollPosition number
--- @field getThrottleLeftPosition number
--- @field getThrottleRightPosition number
--- @field getTotalFuelWeight number
--- @field getTrueAirSpeed number
--- @field getVerticalAcceleration number
--- @field getVerticalVelocity number
--- @field getWOW_LeftMainLandingGear integer
--- @field getWOW_NoseLandingGear integer
--- @field getWOW_RightMainLandingGear integer

------------------------------------------------------------------------------
--- Callbacks
------------------------------------------------------------------------------

--- function called by DCS on cockpit event (avDevice event, listen_event)
--- @param command number
--- @param value table
function CockpitEvent(command, value) end

--- function called by DCS when a command is triggered
function SetCommand(command, value) end

--- function called by DCS when damage is triggered (not working)
function SetDamage(command, value) end

--- function called by DCS when a failure is triggered (not working)
function SetFailure(command, value) end

--- function called by DCS post initialize
function post_initialize() end

--- update function (used with make_default_activity)
function update() end

-- exported values in clickabledata
show_element_boxes = true
show_element_parent_boxes = true
show_indicator_borders = true
show_other_pointers = true
show_tree_boxes = false
enable_commands_log = true
use_click_and_pan_mode = true

--- @param type string @aicraft type
--- @param name string @livery name or "default"
function find_custom_livery(type, name) end

--- exported values in mainpanel_init
--- todo..

-- avDevice classes:
-- avABU11Clock
-- avAChS_1
-- avAdjustableVariometer
-- avAFN2
-- avAirDrivenTurnIndicator
-- avArtificialHorizont_AN5736
-- avAutostartDevice
-- avBaseIKP
-- avBasicHearingSensitivityInterface
-- avBasicLightSystem
-- avBasicOxygenSystemInterface
-- avDirectionalGyro_AN5735
-- avExternalCargoSpeech
-- avGH3000
-- avIntercom
-- avIntercomWWII
-- avK14GunSight
-- avKneeboard
-- avLuaDevice
-- avM800
-- avMechCompass
-- avNightVisionGoggles
-- avNightVisionGogglesV2
-- avPadlock
-- avRemoteCompass_AN5730
-- avSimpleAirspeedIndicator
-- avSimpleAltimeter
-- avSimpleElectricSystem
-- avSimpleVariometer
-- avSimpleRWR
-- avSimpleWeaponSystem
-- avTACAN_ARN118
-- avTACAN_ARN118_CtrlPanel
-- avUHF_ARC_164
