---------------------------------------------------------------------------
--- PLUGIN ENV
--- used by entry.lua in plugins
---
--- also available:
---  dofile, loadfile
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--- Declaring plugin
---------------------------------------------------------------------------

--- Starts plugin declaration.
--- @param name string @name of the plugin
--- @param props PluginProperties @plugin properties
function declare_plugin(name, props) return end

--- Finalizes plugin declaration.
function plugin_done() return end

--- Absolute path to current plugin
current_mod_path = ""

---------------------------------------------------------------------------
--- Add stuff
---------------------------------------------------------------------------

--- Adds an NPC aircraft
--- @param data AircraftData @aircraft data
function add_aircraft(data) return end

--- Adds a launcher
--- @param ws_data table
--- @param data table @launcher data
--- @return table
function add_launcher(ws_data, data) return end

--- ??
function add_navpoint() return end

--- Adds a plugin system
--- @param plugin_id string @plugin system name
--- @param match string @unsure if it's a match, "*" can be used
--- @param cockpit_path string @path to cockpit scripts dir
--- @param aircraft_options table @key: typename, value: options
function add_plugin_systems(plugin_id, match, cockpit_path, aircraft_options) return end

--- Adds a surface unit
--- @param gt_data GTData
function add_surface_unit(gt_data) return end

--- ??
function add_unit_to_country() return end

--- ??
function declare_callbackME() return end

--- Declares a gun mount. Looks like obsolete and use declare_weapon instead?
--- @param name string
--- @param gun_data table
function declare_gun_mount(name, gun_data) return end

--- Declares a loadout
--- @param loadout_data table
function declare_loadout(loadout_data) return end

--- Declares a sensor
--- @param sensor_data table
function declare_sensor(sensor_data) return end

--- Declares service life for an object
--- @param obj_name string @name of the object
--- @param country_name string @name of the country
--- @param from_year number @start year
--- @param to_year number @end year
function declare_service_life(obj_name, country_name, from_year, to_year) return end

--- Declares a weapon
--- @param weapon_data table
function declare_weapon(weapon_data) return end

--- Makes an object flyable
--- @param obj_name string @name of the object created by add_aircraft
--- @param cockpit_path string @path to the cockpit scripts (optional)
--- @param fm FM @optional flight model. if nil, then SFM is used
--- @param comm_path string @path to the comm.lua script (radio menu)
function make_flyable(obj_name, cockpit_path, fm, comm_path) return end

--- MACs a flyable object (FC? who knows, but it's used in F15C)
--- @param obj_name string @name of the object
--- @param cockpit_path string @path to the cockpit scripts (optional)
--- @param fm FM @optional flight model. if nil, then SFM is used
--- @param comm_path string @path to the comm.lua script (radio menu)
function MAC_flyable(obj_name, cockpit_path, fm, comm_path) return end

--- Makes a payload rules list
--- @param stations number[] @stations requiring CLSIDs
--- @param CLSIDs string[] @required CLSIDs
function make_payload_rules_list(stations, CLSIDs) return end

--- Makes view settings for an aircraft
--- @param obj_name string @name of the object created by add_aircraft
--- @param viewSettings table @view settings table
--- @param snapViews table @snap views table
function make_view_settings(obj_name, viewSettings, snapViews) return end

---------------------------------------------------------------------------
--- FM parameters
---------------------------------------------------------------------------

--- @class FM
--- @description [1] = plugin_id_of_fm_origin, [2] = dll_with_fm
--- @field center_of_mass table @{ x, y, z }
--- @field moment_of_inertia table @{ Ix, Iy, Iz, Ixy }
--- @field suspension table
--- @field config_path string @path to FM config file (for ed_fm_configure)
--- @field user_options string @flyable ID
--- @field old any @true (F-15C), 3 (Su-27), 4 (Su-33), 6 (F-15 SFM), 54 (Su-25T)

---------------------------------------------------------------------------
--- Resource paths
---------------------------------------------------------------------------

--- Mounts an animations path
--- @param path string @path
function mount_vfs_animations_path(path) return end

--- Mounts a liveries path
--- @param path string @path
function mount_vfs_liveries_path(path) return end

--- Mounts a model path
--- @param path string @path
function mount_vfs_model_path(path) return end

--- Mounts a sound path (obsolete)
--- @param path string @path
function mount_vfs_sound_path(path) return end

--- Mounts a texture path
--- @param path string @path
function mount_vfs_texture_path(path) return end

---------------------------------------------------------------------------
--- Effect parameters
---------------------------------------------------------------------------

--- Returns fire effect parameters
--- @param fire_arg table @fire argument table
--- @param duration number @duration
--- @param attenuation number @attenuation
--- @param light_pos table @light position { x, y, z }
function fire_effect(fire_arg, duration, attenuation, light_pos) return end

--- Returns gatling effect parameters
--- @param gatling_arg table @gatling argument
--- @param duration number @duration
function gatling_effect(gatling_arg, duration) return end

--- Returns smoke effect parameters
--- @return table @smoke effect parameters
function smoke_effect() return end

---------------------------------------------------------------------------
--- Warhead parameters
---------------------------------------------------------------------------

--- Returns antiship warhead parameters
--- @param power number @kg
--- @param caliber number @caliber in mm
--- @return table @warhead parameters
function antiship_penetrating_warhead(power, caliber) return end

--- Returns cumulative warhead parameters
--- @param a number
--- @param b number
--- @return table @warhead parameters
function cumulative_warhead(a, b) return end

--- Returns directional A2A warhead parameters
function directional_a2a_warhead() return end

--- Returns enhanced A2A warhead parameters
--- @param power number @kg
--- @param caliber number @caliber in mm
--- @return table @warhead parameters
function enhanced_a2a_warhead(power, caliber) return end

--- Returns penetrating warhead parameters
--- @param power number @kg
--- @param caliber number @caliber in mm
--- @return table @warhead parameters
function penetrating_warhead(power, caliber) return end

--- Returns predefined warhead parameters
--- @param name string @name of the warhead
--- @return table @warhead parameters
function predefined_warhead(name) return end

--- Returns simple AA warhead parameters
--- @param power number @kg
--- @return table @warhead parameters.
function simple_aa_warhead(power) return end

--- Returns simple warhead parameters.
--- @param power number @kg
--- @param caliber number @caliber in mm
--- @return table @warhead parameters
function simple_warhead(power, caliber) return end

---------------------------------------------------------------------------
--- Fuze parameters
---------------------------------------------------------------------------

--- Returns predefined fuze parameters
--- @param name string @name of the fuze
--- @return table @fuze parameters.
function predefined_fuze(name) return end

--- Returns specialized fuze parameters
--- @param base_params table @base fuze parameters
--- @param params table @modified parameters
--- @return table @specialized fuze parameters
function specialize_fuze_parameters(base_params, params) return end

---------------------------------------------------------------------------
--- Weapons
---------------------------------------------------------------------------

--- Returns cluster description
--- @param name string @name of the cluster
--- @param type number @type of the cluster
--- @param data table @cluster data
--- @return table @cluster description
function cluster_desc(name, type, data) return end

--- Combines cluster parameters
--- @param a table @cluster a
--- @param b table @cluster b
--- @param name string @name of the cluster
--- @return table @combined cluster
function combine_cluster(a, b, name) return end

--- ??
function get_bomb_munition() return end

--- Returns predefined aircraft gunpod parameters
--- @param name string @name of the gunpod
--- @return table @gunpod parameters
function get_predefined_aircraft_gunpod(name) return end

--- Returns gun mount parameters
--- @param name string @name of the gun mount
--- @param ammo_override table @ammo overrides. { count = 90 }
--- @param mount_override table @mount overrides
--- @param trigger_override table @trigger overrides
function gun_mount(name, ammo_override, mount_override, trigger_override) return end

--- Returns pylon parameters
--- @param index number @index of the pylon
--- @param weapon_start number @default weapon start (0 - rail, 1 - catapult, > 1 - from hatch)
--- @param x number @coordinates in aircraft space, can be 0, 0, 0 if connector is used
--- @param y number @coordinates in aircraft space, can be 0, 0, 0 if connector is used
--- @param z number @coordinates in aircraft space, can be 0, 0, 0 if connector is used
--- @param connector_data table @connector data
--- @param pylon_data table @pylon data
--- @return table @pylon parameters
function pylon(index, weapon_start, x, y, z, connector_data, pylon_data) return end

--- Returns predefined weapon engine parameters
--- @param name string @name of the engine
--- @return table @engine parameters
function predefined_engine(name) return end

--- Returns predefined weapon FM parameters
--- @param name string @name of the FM
--- @return table @FM parameters
function predefined_fm(name) return end

--- Returns specialized weapon engine parameters
--- @param base_params table @base engine parameters
--- @param params table @modified parameters
--- @return table @specialized engine parameters
function specialize_engine_parameters(base_params, params) return end

--- Returns specialized weapon FM parameters
--- @param base_params table @base FM parameters
--- @param params table @modified parameters
--- @return table @specialized FM parameters
function specialize_fm_parameters(base_params, params) return end

---------------------------------------------------------------------------
--- Misc
---------------------------------------------------------------------------

--- Creates aircraft task
--- @param task string @task name: "Nothing", "SEAD", "AntishipStrike", "AWACS", "CAS", "CAP", "Escort", "FighterSweep", "GAI", "GroundAttack", "Intercept", "AFAC", "PinpointStrike", "Reconnaissance", "Refueling", "RunwayAttack", "Transport"
--- @return table @task data
function aircraft_task(task) return end

--- Locks player interaction
--- @param type string @unit type
function lock_player_interaction(type) return end

--- ??
function make_aircraft_carrier_capable() return end

--- Makes default mech animation
--- @param preset string @preset name
--- @return table @mech animation data
function make_default_mech_animation(preset) return end

--- Makes airplane canopy geometry. LOOK_BAD, LOOK_AVERAGE, LOOK_GOOD
--- @param a number
--- @param b number
--- @param c number
--- @return table @CanopyGeometry data
function makeAirplaneCanopyGeometry(a, b, c) return end

--- Makes helicopter canopy geometry
--- @param a number
--- @param b number
--- @param c number
--- @return table @CanopyGeometry data
function makeHelicopterCanopyGeometry(a, b, c) return end

--- Sets manual path
--- @param obj_name string @name of the object
--- @param path string @path to the manual
function set_manual_path(obj_name, path) return end

--- ??
function turn_on_waypoint_panel() return end

--- Unlocks player interaction
--- @param type string @unit type
function unlock_player_interaction(type) return end

--- Returns Damage parameters
--- @param data table
--- @return table @damage parameters
function verbose_to_dmg_properties(data) return end

--- Returns Failures parameters
--- @param data table
--- @return table @failures parameters
function verbose_to_failures_table(data) return end

---------------------------------------------------------------------------
--- GUI functions
---------------------------------------------------------------------------

--- ??
--- @param name string
function Get_Combined_GUISettings_Preset(name) return end

--- ??
--- @param name string
function Get_Fuze_GUISettings_Preset(name) return end

--- ??
--- @param name string
function Get_LGU_GUISettings_Preset(name) return end

--- ??
--- @param name string
function Get_RFGU_GUISettings_Preset(name) return end

---------------------------------------------------------------------------
--- Plugin properties
---------------------------------------------------------------------------

--- @class PluginProperties
--- @description plugin properties, many of these fields are optional.
--- @field binaries table<string> @strings representing names of binary executable files (.dll) to inject
--- @field developerName string @name of developer
--- @field developerLink string @link to developer
--- @field dirName string @name of the directory containing the plugin
--- @field displayName string @localized name of the plugin shown within UI elements. (exc. module viewer)
--- @field encyclopedia_path string @file path pointing towards an Encyclopedia folder containing Plane/plugin_name.txt
--- @field fileMenuName string @localized name of the file containing the flyable declaration
--- @field info string @localized description of the plugin, shown in the main menu
--- @field installed boolean @can the player can interact with the plugin? (e.g. settings, mission editor)
--- @field load_immediately boolean
--- @field registryPath string @e.g. "Eagle Dynamics\\NS430"
--- @field rules table @e.g. { ["jsAvionics"] = {required = true} }
--- @field shortName string @short name
--- @field state string @string representing plugin accessibility state. (“installed” or “uninstalled”)
--- @field update_id string @id to check for in DCS updates
--- @field version string @__DCS_VERSION__
--- @field InputProfiles table<string,string> @array with input profiles (["input_id"] = "path/to/inputdir")
--- @field LogBook PluginLogBookTable @defines the path and UI representation for the pilot logbook
--- @field MAC_ignore boolean
--- @field Missions PluginMissionsTable @defines the path and UI representation for flyable missions
--- @field Options PluginOptionsTable @option properties
--- @field Skins PluginSkinsTable @defines the path and representation of UI elements

--- @class PluginSkinsTable
--- @description Skins table
--- @field name string @name of the plugin to show within most UI
--- @field dir string @folder path of elements used

--- @class PluginMissionsTable
--- @description Missions table
--- @field name string @name of the plugin to show within most UI
--- @field dir string @folder path of mission files used
--- @field CLSID string @customisable string text

--- @class PluginLogBookTable
--- @description LogBook table
--- @field name string @name of the plugin to show within most UI
--- @field type string @plugin type

--- @class PluginInputProfilesTable

--- @class PluginOptionsTable
--- @description Option properties
--- @field name string @name of the plugin to show within most UI
--- @field nameId string @id of the plugin used for options
--- @field dir string @folder path of option settings used
--- @field CLSID string @class id (any string)

---------------------------------------------------------------------------
--- Aircraft data
---------------------------------------------------------------------------

---@class AircraftData
---@description Aircraft data table
---@field Name string
---@field DisplayName string
---@field Picture string
---@field Rate number @rewardpoint in mp
---@field Shape string
---@field WorldID string
---@field ViewSettings table
---@field Countries table
---@field HumanCockpit boolean
---@field HumanCockpitPath string
---@field net_animation table
---@field shape_table_data table
---@field CanopyGeometry table @from makeAirplaneCanopyGeometry(), { azimuth = { a, b }, elevation = { c, d } }
---@field mapclasskey string
---@field attribute table
---@field Categories table
---@field sounderName string
-- general characteristics
---@field singleInFlight boolean
---@field length number
---@field height number
---@field wing_area number
---@field wing_span number
---@field wing_tip_pos table
---@field RCS number
---@field has_speedbrake boolean
---@field stores_number number
---@field tanker_type number
---@field is_tanker boolean
---@field refueling_points_count number
---@field refueling_points table
---@field crew_members table
---@field mechanimations table
---@field EmptyWeight string
---@field MaxFuelWeight string
---@field MaxHeight string
---@field MaxSpeed string
---@field MaxTakeOffWeight string
---@field WingSpan string
-- weight & fuel characteristics
---@field M_empty number
---@field M_nominal number
---@field M_max number
---@field M_fuel_max number
---@field H_max number
---@field CAS_min number
---@field average_fuel_consumption number
-- AI flight parameters
---@field V_opt number
---@field V_take_off number
---@field V_land number
---@field V_max_sea_level number
---@field V_max_h number
---@field Vy_max number @maximal climb rate
---@field Mach_max number
---@field Ny_min number @minimal safe acceleration
---@field Ny_max number @maximal safe acceleration
---@field Ny_max_e number
---@field AOA_take_off number
---@field bank_angle_max number
---@field flaps_maneuver number
---@field range number @operational range
-- suspension characteristics
---@field has_differential_stabilizer boolean
---@field tand_gear_max number
---@field nose_gear_pos table
---@field nose_gear_wheel_diameter number
---@field main_gear_pos table
---@field main_gear_wheel_diameter number
-- engine characteristics
---@field has_afteburner boolean
---@field thrust_sum_max number
---@field thrust_sum_ab number
---@field engines_count number
---@field IR_emission_coeff number
---@field IR_emission_coeff_ab number
---@field engines_nozzles table
-- sensor characteristics
---@field radar_can_see_ground boolean
---@field detection_range_max number
---@field Sensors table
-- radio characteristics
---@field TACAN boolean
---@field HumanRadio table
---@field panelRadio table
-- ECM characteristics
---@field passivCounterm table
---@field Countermeasures table
---@field chaff_flare_dispenser table
-- armament characteristics
---@field Pylons table
---@field Tasks table
---@field DefaultTask table @from aircraft_task()
-- damage
---@field fires_pos table
---@field Damage table @from verbose_to_dmg_properties()
---@field DamageParts table
-- flight model characteristics
---@field SFM_Data table
-- external lights
---@field lights_data table
-- land & takeoff
---@field LandRWCategories table
---@field TakeOffRWCategories table
-- failures
---@field Failures table
-- additional properties
---@field AddPropAircraft table
-- guns
---@field Guns table
---@field ammo_type_default number
---@field ammo_type table
-- sound
---@field sound_name string

---------------------------------------------------------------------------
--- GT templates
---------------------------------------------------------------------------

--- @class GT_t
--- @field BarrelsReloadTypes table
--- @field CH_t table
--- @field GEAR_TYPES table
--- @field LN_t table
--- @field OLS_TYPE table
--- @field SN_visual table
--- @field SS_t table
--- @field START_ALARM_STATES table @RED, GREEN
--- @field WS_t table
--- @field generic_ship table
--- @field generic_stationary table
--- @field generic_tank table
--- @field generic_track_IFV table
--- @field generic_wheel table
--- @field generic_wheel_IFV table
--- @field generic_wheel_vehicle table
--- @field inc_ws fun() @Increment ws
--- @field ws number
--- @type GT_t
GT_t = {}

---------------------------------------------------------------------------
--- GTData
---------------------------------------------------------------------------

--- @class GTData
--- @field AddPropVehicle table
--- @field DetectionRange number
--- @field DisplayName string
--- @field DisplayNameShort string
--- @field IR_emission_coeff number
--- @field Name string
--- @field Rate number
--- @field ThreatRange number
--- @field attribute table
--- @field category string
--- @field chassis table
--- @field driverCockpit string
--- @field driverViewConnectorName string
--- @field mapclasskey string
--- @field sensor table
--- @field tags table
--- @field visual table
