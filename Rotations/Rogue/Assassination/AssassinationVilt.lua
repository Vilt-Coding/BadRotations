local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)   
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    
---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local combatTime                                    = getCombatTime()
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
    local gcd                                           = br.player.gcd
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local level                                         = br.player.level
    local lowestHP                                      = br.friend[1].unit
    local mode                                          = br.player.mode
    local perk                                          = br.player.perk        
    local php                                           = br.player.health
    local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local recharge                                      = br.player.recharge
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local ttm                                           = br.player.timeToMax
    local units                                         = br.player.units
    
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
    -- Pause
    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
        return true
    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then

        end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if inCombat then

        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation 
local id = 000 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

--[[
# This default action priority list is automatically created based on your character.
# It is a attempt to provide you with a action list that is both simple and practicable,
# while resulting in a meaningful and good simulation. It may not result in the absolutely highest possible dps.
# Feel free to edit, adapt and improve it to your own needs.
# SimulationCraft is always looking for updates and improvements to the default action lists.

# Executed before combat begins. Accepts non-harmful actions only.
actions.precombat=flask,name=flask_of_the_seventh_demon
actions.precombat+=/augmentation,name=defiled
actions.precombat+=/food,name=lavish_suramar_feast
# Snapshot raid buffed stats before combat begins and pre-potting is done.
actions.precombat+=/snapshot_stats
actions.precombat+=/apply_poison
actions.precombat+=/stealth
actions.precombat+=/potion,name=old_war
actions.precombat+=/marked_for_death,if=raid_event.adds.in>40

# Executed every time the actor is available.
actions=variable,name=energy_targetbleed_regen,value=energy.regen+bleeds*(7+talent.venom_rush.enabled*3)%2
actions+=/call_action_list,name=cds
actions+=/call_action_list,name=maintain
# The 'active_dot.rupture>=spell_targets.rupture' means that we don't want to envenom as long as we can multi-rupture (i.e. units that don't have rupture yet).
actions+=/call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=4)&active_dot.rupture>=spell_targets.rupture
actions+=/call_action_list,name=build,if=combo_points.deficit>0|energy.deficit<=25+variable.energy_targetbleed_regen

# Builders
actions.build=hemorrhage,if=refreshable
actions.build+=/hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<2+talent.agonizing_poison.enabled+(talent.agonizing_poison.enabled&equipped.insignia_of_ravenholdt)
actions.build+=/fan_of_knives,if=spell_targets>=2+talent.agonizing_poison.enabled+(talent.agonizing_poison.enabled&equipped.insignia_of_ravenholdt)|buff.the_dreadlords_deceit.stack>=29
actions.build+=/mutilate,cycle_targets=1,if=(!talent.agonizing_poison.enabled&dot.deadly_poison_dot.refreshable)|(talent.agonizing_poison.enabled&debuff.agonizing_poison.remains<debuff.agonizing_poison.duration*0.3)
actions.build+=/mutilate,if=energy.deficit<=25+variable.energy_targetbleed_regen|debuff.vendetta.up|dot.kingsbane.ticking|cooldown.vendetta.remains<=6|target.time_to_die<=6

# Cooldowns
actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|debuff.vendetta.up&cooldown.vanish.remains<5
actions.cds+=/use_item,name=draught_of_souls,if=energy.deficit>=35+variable.energy_targetbleed_regen*2&(!equipped.mantle_of_the_master_assassin|cooldown.vanish.remains>8)&(!talent.agonizing_poison.enabled|debuff.agonizing_poison.stack>=5&debuff.surge_of_toxins.remains>=3)
actions.cds+=/use_item,name=draught_of_souls,if=mantle_duration>0&mantle_duration<3.5&dot.kingsbane.ticking
actions.cds+=/blood_fury,if=debuff.vendetta.up
actions.cds+=/berserking,if=debuff.vendetta.up
actions.cds+=/arcane_torrent,if=dot.kingsbane.ticking&!buff.envenom.up&energy.deficit>=15+variable.energy_targetbleed_regen*gcd.remains*1.1
actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit*1.5|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
actions.cds+=/vendetta,if=!artifact.urge_to_kill.enabled|energy.deficit>=60+variable.energy_targetbleed_regen
# Nightstalker w/o Exsanguinate: Vanish Envenom if Mantle & T19_4PC, else Vanish Rupture
actions.cds+=/vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&!talent.exsanguinate.enabled&((equipped.mantle_of_the_master_assassin&set_bonus.tier19_4pc&mantle_duration=0)|((!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(dot.rupture.refreshable|debuff.vendetta.up)))
actions.cds+=/vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&(dot.rupture.ticking|time>10)
actions.cds+=/vanish,if=talent.subterfuge.enabled&equipped.mantle_of_the_master_assassin&(debuff.vendetta.up|target.time_to_die<10)&mantle_duration=0
actions.cds+=/vanish,if=talent.subterfuge.enabled&!equipped.mantle_of_the_master_assassin&!stealthed.rogue&dot.garrote.refreshable&((spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives)|(spell_targets.fan_of_knives>=4&combo_points.deficit>=4))
actions.cds+=/vanish,if=talent.shadow_focus.enabled&energy.time_to_max>=2&combo_points.deficit>=4
actions.cds+=/exsanguinate,if=prev_gcd.1.rupture&dot.rupture.remains>4+4*cp_max_spend

# Finishers
actions.finish=death_from_above,if=combo_points>=5
actions.finish+=/envenom,if=combo_points>=4&(debuff.vendetta.up|debuff.surge_of_toxins.remains<gcd.remains+0.2)
actions.finish+=/envenom,if=talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<gcd.remains+0.2

# Maintain
actions.maintain=rupture,if=talent.nightstalker.enabled&stealthed.rogue&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(talent.exsanguinate.enabled|target.time_to_die-remains>4)
actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&remains<=10&!exsanguinated&target.time_to_die-remains>4
actions.maintain+=/rupture,if=!talent.exsanguinate.enabled&combo_points>=3&!ticking&mantle_duration<=gcd.remains+0.2&target.time_to_die>4
actions.maintain+=/rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled)))
actions.maintain+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
# Sinister Circulation makes it worth to cast Kingsbane on CD, although you shouldn't cast it if you're [stealthed w/ Nighstalker and have Mantle & T19_4PC to Envenom].
actions.maintain+=/kingsbane,if=artifact.sinister_circulation.enabled&combo_points.deficit>=1+(mantle_duration>gcd.remains+0.2)&(talent.subterfuge.enabled|!stealthed.rogue|(talent.nightstalker.enabled&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)))
actions.maintain+=/kingsbane,if=!talent.exsanguinate.enabled&combo_points.deficit>=1+(mantle_duration>gcd.remains+0.2)&buff.envenom.up&((debuff.vendetta.up&debuff.surge_of_toxins.up)|cooldown.vendetta.remains<=5.2)
actions.maintain+=/kingsbane,if=talent.exsanguinate.enabled&combo_points.deficit>=1+(mantle_duration>gcd.remains+0.2)&dot.rupture.exsanguinated
actions.maintain+=/pool_resource,for_next=1
actions.maintain+=/garrote,cycle_targets=1,if=combo_points.deficit>=1&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
]]