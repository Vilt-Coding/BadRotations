local rotationName = "Vilt"
 

 --[[
Todo:
        Add Opener Toggle?
        Add Star Augur Boss logic to Always Facing


 
 ]]
---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.fanOfKnives },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.fanOfKnives },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mutilate },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.vendetta },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.vendetta },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.vendetta }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt",4,0)
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.fanOfKnives },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.mutilate }
    };
end
 
---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
 
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")        
            -- Stealth
            br.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFF000020Yards"},  1, "Stealthing method.")
            -- Poisoned Knife OOR
            br.ui:createCheckbox(section, "Poisoned Knife OOR")
            -- Opener
            br.ui:createCheckbox(section, "Opener")
            -- Open from Stealth, non-Opener
            br.ui:createCheckbox(section, "Open from Stealth")
            br.ui:createCheckbox(section, "Use Boss/Dungeon Logic")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            --Racial
            br.ui:createCheckbox(section,"Racial")
            --Trinkets
            br.ui:createDropdownWithout(section,"Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2, "Not DoS")
            --Vendetta
            br.ui:createCheckbox(section,"Vendetta")
            --Kingsbane Artifact Check
            br.ui:createDropdownWithout(section,"Kingsbane", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Vanish
            br.ui:createCheckbox(section,"Vanish")
            --Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 2)
            br.ui:createDropdownWithout(section,"Draught of Souls", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2)
            -- Target Dotting TTD
            br.ui:createSpinnerWithout(section,"Target Dot TTD", 4, 0, 16, 1, "|cffFFBB00Target Garrote/Rupture | Minimum TTD to use.")
            -- Add Dotting TTD
            br.ui:createSpinnerWithout(section,"Multidot TTD", 8, 0, 16, 1, "|cffFFBB00Multidotting Garrote/Rupture | Minimum TTD to use.")
            br.ui:createSpinnerWithout(section,"Envenom Offset", 3, 0, 10, 0.1, "How many Envenoms worth of damage before we Rupture.") 
            br.ui:createSpinnerWithout(section,"Mantle Offset", 2, 0, 10, 0.1, "Envenom Mantle Offset Multiplier")  
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  35,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")            
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Kidney Shot
            br.ui:createCheckbox(section, "Kidney Shot")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ------------------------
        ---- HACKS And BUGS ----
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Hacks and Bugs")
            br.ui:createCheckbox(section, "Always Facing")
            br.ui:createCheckbox(section, "Talent Hack", "Change Talents without requiring Rested or Tome. Right click to remove talent.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    --Print("Running: "..rotationName)
---------------
--- Toggles ---
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    local artifact                                      = br.player.artifact
    local attacktar                                     = UnitCanAttack("target","player")
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local combatTime                                    = getCombatTime()
    local combo, comboDeficit, comboMax                 = br.player.power.amount.comboPoints, br.player.power.comboPoints.deficit, br.player.power.comboPoints.max
    local deadtar                                       = UnitIsDeadOrGhost("target")
    local debuff                                        = br.player.debuff
    local enemies                                       = enemies or {}
    local flaskBuff, canFlask                           = getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)
    local gcd                                           = br.player.gcd
    local glyph                                         = br.player.glyph
    local hastar                                        = ObjectExists("target")
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local lastSpell                                     = lastCast
    local level                                         = br.player.level
    local mode                                          = br.player.mode
    local perk                                          = br.player.perk
    local php                                           = br.player.health
    local power, powerDeficit, powerRegen, powerTTM     = br.player.power.amount.energy, br.player.power.energy.deficit, GetPowerRegen(Unit), br.player.power.ttm
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local solo                                          = #br.friend < 2
    local spell                                         = br.player.spell
    local stealth                                       = br.player.buff.stealth.exists()
    local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()  or br.player.buff.subterfuge.exists()
    local stealthingRogue                               = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.subterfuge.exists()
    local stealthingMantle                              = br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
    local t19_2pc                                       = TierScan("T19") >= 2
    local t19_4pc                                       = TierScan("T19") >= 4
    local talent                                        = br.player.talent
    local ttd                                           = getTTD
    local ttm                                           = br.player.power.ttm
    local units                                         = units or {}
    local lootDelay                                     = getOptionValue("LootDelay")
    local bleedTickTime, exsanguinatedBleedTickTime     = 2, 1
    local RuptureDMGThreshold, GarroteDMGThreshold

    --ChatOverlay(BleedTarget())

    units.dyn5 = br.player.units(5)
    units.dyn5 = br.player.units(8)
    enemies.yards5 = br.player.enemies(5)
    enemies.yards8 = br.player.enemies(8)
    enemies.yards10 = br.player.enemies(10)
    enemies.yards20 = br.player.enemies(20)
    enemies.yards30 = br.player.enemies(30)
    enemies.yards40 = br.player.enemies(40)

    local function TalentHack()
        local hide
        if not PlayerTalentFrame then ToggleTalentFrame() hide = true end
        local frame
        local function rightClickRemove(self, button, down)
            if button == "RightButton" then
                for r = 1, 7 do
                    for c = 1, 3 do
                        frame = _G["PlayerTalentFrameTalentsTalentRow"..r.."Talent"..c]
                        if frame and frame:IsVisible() and frame:IsMouseOver() then RemoveTalent(GetTalentInfo(r, c, 1)) RemoveTalent(GetTalentInfo(r, c, 1)) end
                    end
                end
            end
        end

        for r = 1, 7 do
            for c = 1, 3 do
                frame = _G["PlayerTalentFrameTalentsTalentRow"..r.."Talent"..c]
                if frame then frame:SetScript("PostClick", rightClickRemove) end
            end
        end
        if hide then HideUIPanel(PlayerTalentFrame) end
    end

    if isChecked("Talent Hack") then TalentHack() end
    if isChecked("Always Facing") and not IsHackEnabled("AlwaysFacing") then SetHackEnabled("AlwaysFacing", true) end
    if not isChecked("Always Facing") and IsHackEnabled("AlwaysFacing") then SetHackEnabled("AlwaysFacing", false) end

    local function poisoned(Unit)
        return (debuff.deadlyPoison.exists(Unit) or debuff.agonizingPoison.exists(Unit) or debuff.woundPoison.exists(Unit)) and true or false
    end

    local function poisonRemains(Unit)
        return (debuff.deadlyPoison.exists(Unit) and debuff.deadlyPoison.remain(Unit)) or
               (debuff.agonizingPoison.exists(Unit) and debuff.agonizingPoison.remain(Unit)) or
               (debuff.woundPoison.exists(Unit) and debuff.woundPoison.remain(Unit)) or 0
    end

    local poisonedBleedsCount = 0
    local function poisonedBleeds()
        poisonedBleedsCount = 0
        for _, Unit in pairs(enemies.yards40) do
            if poisoned(Unit) then
                if debuff.garrote.exists(Unit) then
                    poisonedBleedsCount = poisonedBleedsCount + 1
                end
                if debuff.internalBleeding.exists(Unit) then
                    poisonedBleedsCount = poisonedBleedsCount + 1
                end
                if debuff.rupture.exists(Unit) then
                    poisonedBleedsCount = poisonedBleedsCount + 1
                end
            end
        end
        return poisonedBleedsCount
    end


    --ChatOverlay(poisonedBleeds())
 
    local function energyRegenCombined()
        return powerRegen + poisonedBleeds() * (7 + (talent.venomRush and 3 or 0)) / 2
    end

    --ChatOverlay(energyRegenCombined())

    local function energyTimeToMaxCombined()
        return powerDeficit / energyRegenCombined()
    end
    
    if not debuff.rupture.exists("target") or debuff.rupture.remain("target") < 1.5 then exRupture = false end
    if not debuff.garrote.exists("target") or debuff.rupture.remain("target") < 1.5 then exGarrote = false end
    if lastSpell == spell.exsanguinate then exsanguinateCast = true else exsanguinateCast = false end
    if exsanguinateCast and debuff.rupture.exists("target") then exRupture = true end
    if exsanguinateCast and debuff.garrote.exists("target") then exGarrote = true end
    if exRupture or exGarrote then exsanguinated = true else exsanguinated = false end

    if opener == nil then opener = false end
    if not inCombat and not ObjectExists("target") and lastSpell ~= spell.vanish then
        GAR1 = false
        MUT1 = false
        RUP1 = false
        MUT2 = false
        MUTMAX = false
        VAN1 = false
        RUP2 = false
        VEN1 = false
        MUT3 = false
        KIN1 = false
        ENV1 = false
        opener = false
    end   

    --someone pls fix ttd.....
    local function ttdBrokenTarget()
        if ttd("target") == -1 or ttd("target") == -2 or ttd("target") == 0 then 
            return true 
        else 
            return false 
        end
    end


    --ChatOverlay(ttdBrokenTarget())

    local T19_4PC_BaseMultiplier = 0.1
    local function T19_4PC_EnvMultiplier()
        return 1 + T19_4PC_BaseMultiplier * (BleedTarget() + (debuff.mutilatedFlesh.exists("target") and 1 or 0))
    end

    --ChatOverlay(T19_4PC_EnvMultiplier())

    local function DamageBuff_M()
        if UnitBuffID("player",206466) then
            return 1.3
        else
            return 1
        end
    end



    --AP * CP * Env_APCoef * AssaResolv_M * Aura_M * ToxicB_M * T19_4PC_M * DS_M * AgoP_M * Mastery_M * Versa_M * Crit_M * SlayersPrecision_M * SiUncrowned_M * DamageBuff_M
    local function EnvenomDMG()
        return(
            UnitAttackPower("player") * 
            ComboSpend() * 
            0.6 * 
            1.17 * 
            1.11 *
            (artifact.toxicBlades and 1 + artifact.rank.toxicBlades*0.0333 or 1) *
            (tier19_4pc and T19_4PC_EnvMultiplier() or 1) *
            (talent.deeperStrategem and 1.05 or 1) *
            (debuff.agonizingPoison.exists("target") and 1 + select(17, UnitDebuff("target", "Agonizing Poison")) / 100 or 1) *
            (1 + (GetMasteryEffect("player") / 100)) *
            (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100)) *
            --(1 + (GetCritChance("player") / 100)) *
            (artifact.slayersPrecision and 1.05 or 1) *
            (artifact.silenceOfTheUncrowned and 1.1 or 1) *
            DamageBuff_M()
            )
    end

    RuptureDMGThreshold = EnvenomDMG()*getOptionValue("Envenom Offset")
    GarroteDMGThreshold = EnvenomDMG()*getOptionValue("Envenom Offset")/3

    local function canDot (Unit, Threshold)
        return (UnitHealth(Unit) >= Threshold or isDummy(Unit) or isBoss(Unit))
    end

    --canDot("target", EnvenomDMG() * getOptionValue("Envenom Offset"))

    local function rogueCanDot (Unit, Threshold)
        return canDot(Unit, Threshold * (mantleDuration() > 0 and (getOptionValue("Mantle Offset")) or 1))
    end

    --rogueCanDot("target", EnvenomDMG() * getOptionValue("Envenom Offset"))
    --ChatOverlay(EnvenomDMG())

--------------------
--- Action Lists ---
--------------------
    local function actionList_MythicDungeon()
        if UnitDebuffID("player",200904) then
            if getDistance("target") <= 5 then
                if cast.kick() then return end
            end
            if cd.kick ~= 0 then
                if cast.blind() then return end
            end
            if cd.kick ~= 0 then
                if cast.evasion() then return end
            end
            if ttm <= gcd and getDistance("target") > 5 and cd.kick ~= 0 then
                if cast.crimsonVial() then return end
            else
                if cast.feint() then return end
            end
        end
    end
-- Action List - Extras
    local function actionList_Extras()
               
    end -- End Action List - Extras
-- Action List - Defensives
    local function actionList_Defensive()
        if useDefensive() and not stealth then
        -- Healthstone
            if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUse(5512) then
                    useItem(5512)
                elseif canUse(healPot) then
                    useItem(healPot)
                end
            end
        end
    end -- End Action List - Defensive
-- Action List - Interrupts
    local function actionList_Interrupts()
        if useInterrupts() and not stealth then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Kick
                    -- kick
                    if isChecked("Kick") and distance < 5 then
                        if cast.kick(thisUnit) then return end
                    end
        -- Kidney Shot
                    if cd.kick ~= 0 and cd.blind == 0 then
                        if isChecked("Kidney Shot") then
                            if cast.kidneyShot(thisUnit) then return end
                        end
                    end
                    if isChecked("Blind") and (cd.kick ~= 0 or distance >= 5) then
        -- Blind
                        if cast.blind(thisUnit) then return end
                    end
                end
            end
        end -- End Interrupt and No Stealth Check
    end -- End Action List - Interrupts
-- Action List - Build
    local function actionList_Build()
    --actions.build=hemorrhage,if=refreshable
        if talent.hemorrhage and debuff.hemorrhage.refresh("target") then
            if cast.hemorrhage("target") then return end
        end
    --actions.build+=/hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<2+talent.agonizing_poison.enabled+(talent.agonizing_poison.enabled&equipped.insignia_of_ravenholdt)
        if talent.hemorrhage then
            if ((mode.rotation == 1 and #getEnemies("player",9.6) < 2 + (buff.agonizingPoison.exists() and 1 or 0) + (buff.agonizingPoison.exists() and hasEquiped(137049) and 1 or 0)) or mode.rotation == 2) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if debuff.hemorrhage.refresh(thisUnit) and debuff.rupture.exists(thisUnit) and ttd(thisunit) < 9001 then
                        if cast.hemorrhage(thisUnit) then return end
                    end
                end
            end
        end
    --actions.build+=/fan_of_knives,if=spell_targets>=2+talent.agonizing_poison.enabled+(talent.agonizing_poison.enabled&equipped.insignia_of_ravenholdt)|buff.the_dreadlords_deceit.stack>=29
        if ((mode.rotation == 1 and #getEnemies("player",9.6) >= 2 + (buff.agonizingPoison.exists() and 1 or 0) + (buff.agonizingPoison.exists() and hasEquiped(137049) and 1 or 0)) or mode.rotation == 2) or buff.theDreadlordsDeceit.stack() >= 29 then
            if cast.fanOfKnives() then return end
        end
    --actions.build+=/mutilate,cycle_targets=1,if=(!talent.agonizing_poison.enabled&dot.deadly_poison_dot.refreshable)|(talent.agonizing_poison.enabled&debuff.agonizing_poison.remains<debuff.agonizing_poison.duration*0.3)
        if (buff.deadlyPoison.exists() and debuff.deadlyPoison.refresh("target")) or (buff.agonizingPoison.exists() and debuff.agonizingPoison.refresh("target")) then
            if cast.mutilate("target") then return end
        end
        if ((mode.rotation == 1 and #enemies.yards5 > 1) or mode.rotation == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if ((buff.deadlyPoison.exists() and debuff.deadlyPoison.exists(thisUnit) and debuff.deadlyPoison.refresh(thisUnit)) or (buff.agonizingPoison.exists() and debuff.agonizingPoison.exists(thisUnit) and debuff.agonizingPoison.refresh(thisUnit))) and ttd(thisUnit) < 9001 then
                    if cast.mutilate(thisUnit) then return end
                end
            end
        end
    --actions.build+=/mutilate,if=energy.deficit<=25+variable.energy_regen_combined|debuff.vendetta.up|dot.kingsbane.ticking|cooldown.exsanguinate.up|cooldown.vendetta.remains<=6|target.time_to_die<=6
        if powerDeficit <= 25 + energyRegenCombined() or debuff.vendetta.exists("target") or debuff.kingsbane.exists("target") or
        (useCDs() and cd.exsanguinate == 0 and talent.exsanguinate) or ttd("target") < 6 or (useCDs() and cd.vendetta <= 6 and artifact.urgeToKill) then
            if cast.mutilate() then return end
        end
    end -- End Action List - Build
-- Action List - CDs
    local function actionList_CDs()
        if not isMoving("player") and getOptionValue("Draught of Souls") == 1 or (getOptionValue("Draught of Souls") == 2 and useCDs()) and hasEquiped(140808) and canUse(140808) then
        --actions.cds+=/use_item,name=draught_of_souls,if=energy.deficit>=35+variable.energy_regen_combined*2&(!equipped.mantle_of_the_master_assassin|cooldown.vanish.remains>8)&(!talent.agonizing_poison.enabled|debuff.agonizing_poison.stack>=5&debuff.surge_of_toxins.remains>=3)
            if powerDeficit >= 35 + (energyRegenCombined() * 2) and (not hasEquiped(144236) or cd.vanish > 8) and (not buff.agonizingPoison.exists() or (debuff.agonizingPoison.stack() >=5 and debuff.surgeOfToxins.remain() >= 3)) then
                useItem(140808)
            end
        --actions.cds+=/use_item,name=draught_of_souls,if=mantle_duration>0&mantle_duration<3.5&dot.kingsbane.ticking
            if mantleDuration() > 0 and mantleDuration() < 3.5 and debuff.kingsbane.exists() then
                useItem(140808)
            end
        end
        --actions.cds+=/use_item,name=tirathons_betrayal,if=buff.bloodlust.react|target.time_to_die<=20|debuff.vendetta.up
        if getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs()) and not hasEquiped(140808) then
            if hasBloodLust() or (debuff.agonizingPoison.stack("target") >= 5 and debuff.vendetta.exists("target")) then
                if canUse(13) then
                    useItem(13)
                end
                if canUse(14) then
                    useItem(14)
                end
            end
        end
        --todo

        --actions.cds+=/blood_fury,if=debuff.vendetta.up
        --actions.cds+=/berserking,if=debuff.vendetta.up        
        if useCDs() and isChecked("Racial") and debuff.vendetta.exists("target") and (race == "Orc" or race == "Troll") then
            if castSpell("player",racial,false,false,false) then return end
        end
        --actions.cds+=/arcane_torrent,if=dot.kingsbane.ticking&!buff.envenom.up&energy.deficit>=15+variable.energy_regen_combined*gcd.remains*1.1
        if useCDs() and isChecked("Racial") and race == "BloodElf" and debuff.kingsbane.exists("target") and not buff.envenom.exists() and powerDeficit >= 15 + energyRegenCombined() * cd.global then
            if castSpell("player",racial,false,false,false) then return end
        end
        --actions.cds+=/vendetta,if=!artifact.urge_to_kill.enabled|energy.deficit>=60+variable.energy_regen_combined
        if useCDs() and isChecked("Vendetta") and cd.global <= 0.25 and (not artifact.urgeToKill or powerDeficit >= 60 + energyRegenCombined()) then
            if cast.vendetta("target") then return end
        end
        if useCDs() and isChecked("Vanish") and (not solo or isDummy()) and cd.global <= getLatency() and power >= 35 then
            if talent.nightstalker and combo >= ComboMaxSpend() then
        --actions.cds+=/vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&!talent.exsanguinate.enabled&((equipped.mantle_of_the_master_assassin&set_bonus.tier19_4pc&mantle_duration=0)|((!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(dot.rupture.refreshable|debuff.vendetta.up)))
                if not talent.exsanguinate and ((hasEquiped(144236) and tier19_4pc and mantleDuration() == 0) 
                    or ((not hasEquiped(144236) or not tier19_4pc) and ((debuff.rupture.refresh("target") and rogueCanDot("target", RuptureDMGThreshold)) or debuff.vendetta.exists()))) then
                    if cast.vanish() then return end
                end
        --actions.cds+=/vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&(dot.rupture.ticking|time>10)
                if talent.exsanguinate and cd.exsanguinate < 1 and (debuff.rupture.exists("target") or combatTime > 10) then
                    if cast.vanish() then return end
                end
            end
            if talent.subterfuge then
        --actions.cds+=/vanish,if=talent.subterfuge.enabled&equipped.mantle_of_the_master_assassin&(debuff.vendetta.up|target.time_to_die<10)&mantle_duration=0
                if hasEquiped(144236) and (debuff.vendetta.exists("target") or ttd("target") < 10) and mantleDuration() == 0 then
                    if cast.vanish() then return end
                end
        --actions.cds+=/vanish,if=talent.subterfuge.enabled&!equipped.mantle_of_the_master_assassin&!stealthed.rogue&dot.garrote.refreshable&((spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives)|(spell_targets.fan_of_knives>=4&combo_points.deficit>=4))
                if not hasEquiped(144236) and not stealthingRogue and debuff.garrote.refresh("target") and 
                    ((#getEnemies("player",9.6) <= 3 and comboDeficit >= 1 + #getEnemies("player",9.6)) or (#getEnemies("player",9.6) >= 4 and comboDeficit >= 4)) then
                    if cast.vanish() then return end
                end
            end
        --actions.cds+=/vanish,if=talent.shadow_focus.enabled&variable.energy_time_to_max_combined>=2&combo_points.deficit>=4
            if talent.shadowFocus and energyTimeToMaxCombined() >= 2 and comboDeficit >= 4 then
                if cast.vanish() then return end
            end
        end
        --actions.cds+=/exsanguinate,if=prev_gcd.1.rupture&dot.rupture.remains>4+4*cp_max_spend
        if useCDs() and lastSpell == spell.rupture and debuff.rupture.remain("target") > 4+4*ComboMaxSpend() then
            if cast.exsanguinate() then return end
        end
    end -- End Action List - CDs
-- Action List - Finish
    local function actionList_Finish()
        --actions.finish=death_from_above,if=combo_points>=5
        if talent.deathFromAbove and combo >=5 then
            if cast.deathFromAbove("target") then return end
        end
        --actions.finish+=/envenom,if=combo_points>=4&(debuff.vendetta.up|mantle_duration>=gcd.remains+0.2|debuff.surge_of_toxins.remains<gcd.remains+0.2|energy.deficit<=25+variable.energy_regen_combined
        --combo >= 4 and (debuff.vendetta.exists("target") or debuff.surgeOfToxins.remain("target") < cd.global + 0.2) 
        if combo >= 4 and 
        (debuff.vendetta.exists("target") or mantleDuration() >= cd.global + 0.2 or debuff.surgeOfToxins.remain("target") < cd.global + 0.2 or powerDeficit <= energyRegenCombined() or not rogueCanDot("target", RuptureDMGThreshold)) then
            if cast.envenom("target") then return end
        end
        --actions.finish+=/envenom,if=talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<gcd.remains+0.2
        if talent.elaboratePlanning and combo >= 3+(talent.exsanguinate and 0 or 1) and buff.elaboratePlanning.remain() < cd.global + 0.2 then
            if cast.envenom("target") then return end
        end
    end -- End Action List - Finish
-- Action List - Kingsbane
    local function actionList_Kingsbane()
        --actions.kb=kingsbane,if=artifact.sinister_circulation.enabled&!(equipped.duskwalkers_footpads&equipped.convergence_of_fates&artifact.master_assassin.rank>=6)&(time>25|!equipped.mantle_of_the_master_assassin|(debuff.vendetta.up&debuff.surge_of_toxins.up))&
        --(talent.subterfuge.enabled|!stealthed.rogue|(talent.nightstalker.enabled&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)))
        if artifact.sinisterCirculation and not (hasEquiped(137030) and hasEquiped(140806) and artifact.rank.masterAssassin >= 6) and 
            (combatTime > 25 or not hasEquiped(144236) or (debuff.vendetta.exists("target") and debuff.surgeOfToxins.exists("target"))) and
            (talent.subterfuge or not stealthingRogue or (talent.nightstalker and (not hasEquiped(144236) or not tier19_4pc))) then
            if cast.kingsbane("target") then return end
        end
        --actions.kb+=/kingsbane,if=!talent.exsanguinate.enabled&buff.envenom.up&((debuff.vendetta.up&debuff.surge_of_toxins.up)|cooldown.vendetta.remains<=5.8|cooldown.vendetta.remains>=10)
        if not talent.exsanguinate and buff.envenom.exists() and ((debuff.vendetta.exists("target") and debuff.surgeOfToxins.exists("target")) or cd.vendetta <= 5.8 or cd.vendetta >= 10) then
            if cast.kingsbane("target") then return end
        end
        --actions.kb+=/kingsbane,if=talent.exsanguinate.enabled&dot.rupture.exsanguinated
        if talent.exsanguinate and exRupture then
            if cast.kingsbane("target") then return end
        end
    end
-- Action List - Maintain
    local function actionList_Maintain()        
        if stealthingRogue then
        --actions.maintain=rupture,if=talent.nightstalker.enabled&stealthed.rogue&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(talent.exsanguinate.enabled|target.time_to_die-remains>4)
            if talent.nightstalker and (not hasEquiped(144236) or not tier19_4pc) and (talent.exsanguinate or ((ttdBrokenTarget() == true or ttd("target") > getOptionValue("Target Dot TTD"))) and rogueCanDot("target", RuptureDMGThreshold)) then
                if cast.rupture("target") then return end
            end
        --actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&refreshable&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>4
            if talent.subterfuge and comboDeficit >= 1 then
                if debuff.garrote.refresh("target") and (not exGarrote or debuff.garrote.remain("target") <= exsanguinatedBleedTickTime*2) and (ttdBrokenTarget() == true or ttd("target") - debuff.garrote.remain("target") > getOptionValue("Target Dot TTD") or rogueCanDot("target", GarroteDMGThreshold)) then
                    if cast.garrote("target") then return end
                end
                if ((mode.rotation == 1 and #enemies.yards5 > 1) or mode.rotation == 2) then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if ttd(thisUnit) < 9001 and ttd(thisUnit) - debuff.garrote.remain(thisUnit) > getOptionValue("Multidot TTD") and debuff.garrote.refresh(thisUnit) then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
        --actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&remains<=10&!exsanguinated&target.time_to_die-remains>4
            if talent.subterfuge and comboDeficit >= 1 then
                if debuff.garrote.remain("target") <= 10 and not exGarrote and (ttdBrokenTarget() == true or ttd("target") - debuff.garrote.remain("target") > getOptionValue("Target Dot TTD") or rogueCanDot("target", GarroteDMGThreshold)) then
                    if cast.garrote("target") then  return end
                end
                if ((mode.rotation == 1 and #enemies.yards5 > 1) or mode.rotation == 2) then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if ttd(thisUnit) < 9001 and debuff.garrote.remain(thisUnit) <= 10 and ttd("target") - debuff.garrote.remain(thisUnit) > getOptionValue("Multidot TTD") then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
        end
        --actions.maintain+=/rupture,if=!talent.exsanguinate.enabled&combo_points>=3&!ticking&mantle_duration<=gcd.remains+0.2&target.time_to_die>4
        if not talent.exsanguinate and combo >= 3 and not debuff.rupture.exists("target") and mantleDuration() <= cd.global + 0.2 and 
        (ttd("target") > getOptionValue("Target Dot TTD") or ttdBrokenTarget() == true) and rogueCanDot("target", RuptureDMGThreshold) then
            if cast.rupture("target") then return end
        end
        --actions.maintain+=/rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled)))
        if useCDs() and talent.exsanguinate and ((combo >= ComboMaxSpend() and cd.exsanguinate < 1) or (not debuff.rupture.exists("target") and (combatTime > 10 or combo >= 2 + (artifact.urgeToKill and 1 or 0)))) then
            if cast.rupture("target") then return end
        end
        --actions.maintain+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
        if combo >= 4 then
            if debuff.rupture.refresh("target") and (not exRupture or debuff.rupture.remain("target") <= 1.5) and (ttd("target") - debuff.rupture.remain("target") > getOptionValue("Target Dot TTD") or ttdBrokenTarget() == true) then
                if cast.rupture("target") then return end
            end
            if ((mode.rotation == 1 and #enemies.yards5 > 1) or mode.rotation == 2) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if ttd(thisUnit) < 9001 and ttd(thisUnit) - debuff.rupture.remain(thisUnit) > getOptionValue("Multidot TTD") and debuff.rupture.refresh(thisUnit) then
                        if cast.rupture(thisUnit) then return end
                    end
                end
            end
        end
        --actions.maintain+=/call_action_list,name=kb,if=combo_points.deficit>=1+(mantle_duration>=gcd.remains+0.2)
        if getOptionValue("Kingsbane") == 1 or (getOptionValue("Kingsbane") == 2 and useCDs()) and comboDeficit >= 1 + (mantleDuration() >= cd.global + 0.2 and 1 or 0) then
            if actionList_Kingsbane() then return end
        end
        --actions.maintain+=/pool_resource,for_next=1        
        --actions.maintain+=/actions.maintain+=/garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>4"
        -- todo pmultiplier, fuck events tho
        if (not talent.subterfuge or not (cd.vanish == 0 and cd.vendetta <= 4)) and comboDeficit >= 1 then
            if debuff.garrote.refresh("target") and (not exRupture or debuff.garrote.remain("target") <= 1.5) and
            (ttd("target") - debuff.garrote.remain("target") > getOptionValue("Target Dot TTD") or ttdBrokenTarget() == true or rogueCanDot("target", GarroteDMGThreshold)) then
                if power < 45 then
                    return true
                elseif power >= 45 then
                    if cast.garrote("target") then return end
                end
            end
            if ((mode.rotation == 1 and #enemies.yards5 > 1) or mode.rotation == 2) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if ttd(thisUnit) < 9001 and ttd(thisUnit) - debuff.garrote.remain(thisUnit) > getOptionValue("Multidot TTD") and rogueCanDot("target", RuptureDMGThreshold) and debuff.garrote.refresh(thisUnit) then
                        if power < 45 then
                            return true
                        elseif power >= 45 then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
        end
    end -- End Action List - Maintain


-- Action List - PreCombat
    local function actionList_PreCombat()
        --Stealth
        if not inCombat then
            if isChecked("Stealth") and not stealth and (not IsResting() or isDummy("target")) then
                if getOptionValue("Stealth") == 1 then
                    if cast.stealth() then return end
                end
                if #enemies.yards20 > 0 and getOptionValue("Stealth") == 2 and not IsResting() and GetTime()-leftCombat > lootDelay then
                    for i = 1, #enemies.yards20 do
                        local thisUnit = enemies.yards20[i]
                        if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                            if cast.stealth("player") then return end
                        end
                    end
                end
            end
        end 
    end -- End Action List - PreCombat
-- Action List - Opener
    local function actionList_Opener()
        if isValidUnit("target") and getDistance("target") < 5 then
            if isChecked("Opener") and (isBoss("target") or isDummy()) and opener == false then
                if not GAR1 and cd.global == 0 then
                    if cd.garrote == 0 then
                        Print("Starting Opener")
                        if cast.garrote("target") then GAR1 = true; Print("1. Garrote"); return end
                    else
                        if cd.garrote ~= 0 then
                            Print("Garrote on CD. Skipping opener, opening with Mutilate and going to normal Rotation");
                            GAR1 = true;
                            opener = true;
                            cast.mutilate("target");
                        return end
                    end
                elseif GAR1 and not MUT1 then
                    if cast.mutilate("target") then MUT1 = true; Print("2. Mutilate"); return end
                elseif MUT1 and not RUP1 then
                    if cast.rupture("target") then RUP1 = true; Print("3. Rupture"); return end
                elseif RUP1 and not MUT2 then
                    if cast.mutilate("target") then MUT2 = true; Print("4. Mutilate"); return end
                elseif MUT2 and not MUTMAX and combo < 5 then
                    if cast.mutilate("target") then return end                        
                elseif MUT2 and not MUTMAX and combo >= 5 then
                    if combo >= 5 then MUTMAX = true; Print("5. Mutilated to 5CP"); return end
                --elseif RUP1 and not MUTMAX then
                    --if cast.mutilate("target") then 
                    --    if combo >= 5 then MUTMAX = true; Print("4. Mutilated to 5CP"); return end
                    --end
                elseif MUTMAX and not VAN1 and cd.global <= getLatency() and power >= 25 then
                    if cd.vanish == 0 then
                        if cast.vanish() then VAN1 = true; Print("6. Vanish"); return end
                    else
                        if cd.vanish ~= 0 then
                            Print("5. Vanish on CD");
                            VAN1 = true;
                        return end
                    end
                        --cast.rupture("target"); 
                        --RUP2 = true;
                        --Print("6. Rupture 2");                         
                elseif VAN1 and not RUP2 then
                    if cast.rupture("target") then RUP2 = true; Print("7. Rupture 2"); return end
                elseif RUP2 and not VEN1 and cd.global <= 0.25 then
                    if cd.vendetta == 0 then
                        if cast.vendetta("target") then VEN1 = true; Print("8. Vendetta"); return end
                    else
                        if cd.vendetta ~= 0 then
                            Print("7. Vendetta on CD");
                            VEN1 = true;
                        return end
                    end
                elseif VEN1 and not MUT3 then
                    if cast.mutilate("target") then MUT3 = true; Print("9. Mutilate"); return end
                elseif MUT3 and not KIN1 and cd.global == 0 then
                    if cd.kingsbane == 0 then
                        if cast.kingsbane("target") then KIN1 = true; Print("10. Kingsbane"); return end
                    else
                        if cd.kingsbane ~= 0 then
                            Print("9. Kingsbane on CD");
                            KIN1 = true;
                            return end
                    end
                elseif KIN1 and not ENV1 then
                    if cast.envenom("target") then ENV1 = true; Print("11. Envenom"); return end
                elseif ENV1 then
                    opener = true;
                    Print("Opener Complete");
                    return;
                end
            elseif not inCombat and isChecked("Open from Stealth") and (not isBoss("target") or not isChecked("Opener")) then
                if combo >= 5 then
                    if not debuff.rupture.exists("target") and rogueCanDot("target", RuptureDMGThreshold) then
                        if cast.rupture("target") then return end
                    else
                        if cast.envenom("target") then return end
                    end
                else
                    if cd.garrote == 0 then
                        if cast.garrote("target") then return end
                    else
                        if cast.mutilate("target") then return end
                    end
                end
            end
        end
    end -- End Action List - Opener
---------------------
--- Begin Profile ---
---------------------
--Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
        return true
    else
-----------------------
--- Extras Rotation ---
-----------------------
        --if actionList_Extras() then return end

        if isChecked("Use Boss/Dungeon Logic") then
            if actionList_MythicDungeon() then return end
            --[[if actionList_EmeraldNightmare() then return end
            if actionList_TrialOfValor() then return end
            if actionlist_NightHold() then return end]]
        end
--------------------------
--- Defensive Rotation ---
--------------------------
        if actionList_Defensive() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
        if actionList_PreCombat() then return end
----------------------------
--- Out of Combat Opener ---
----------------------------
        if opener == false then
            if actionList_Opener() then return end
        end
--------------------------
--- In Combat Rotation ---
--------------------------
        if inCombat and profileStop==false and isValidUnit(units.dyn5) then
            if opener == false and isChecked("Opener") and (isBoss("target") or isDummy()) then
                if actionList_Opener() then return end
            else
                if not StartAttack() and getDistance("target") <= 5 and not stealthingAll and not stealth then
                StartAttack()
                end
------------------------------
--- In Combat - Interrupts ---
------------------------------
                if actionList_Interrupts() then return end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
    -- Cooldowns
            -- call_action_list,name=cds
                if getDistance(units.dyn5) <= 6 and attacktar and inCombat then
                    if actionList_CDs() then return end
                end
    -- Marked for Death
            --marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
                if isChecked("Marked For Death") then
                    if getOptionValue("Marked For Death") == 1 then
                        if comboDeficit >= 4 + (talent.deeperStratagem and 1 or 0) + (talent.anticipation and 1 or 0) then
                            if cast.markedForDeath() then return end
                        end
                    end
                    if isChecked("Marked For Death") then
                        if getOptionValue("Marked For Death") == 2 then
                            for i = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                if comboDeficit >= 6 then comboDeficit = ComboMaxSpend() end
                                if ttd(thisUnit) > 0 and ttd(thisUnit) <= 100 then
                                    if ttd(thisUnit) < comboDeficit*1.2 then
                                        if cast.markedForDeath(thisUnit) then return end
                                    end
                                end
                            end
                        end
                    end
                end
            --actions+=/call_action_list,name=maintain
                if actionList_Maintain() then return end
            --actions+=/call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=4)&active_dot.rupture>=spell_targets.rupture
                if  (not useCDs() or not talent.exsanguinate or cd.exsanguinate > 2) and 
                    (not debuff.rupture.refresh("target") or (exRupture and debuff.rupture.remain("target") >= 3.5) or
                    ttd("target")-debuff.rupture.remain("target") <= getOptionValue("Target Dot TTD") or not rogueCanDot("target", RuptureDMGThreshold)) then
                    if actionList_Finish() then return end
                end
            --actions+=/call_action_list,name=build,if=combo_points.deficit>1|energy.deficit<=25+variable.energy_targetbleed_regen
                if comboDeficit > 1 or powerDeficit <= 25 + energyRegenCombined() then
                    if actionList_Build() then return end
                end
            -- Poisoned Knife OOR
                if isChecked("Poisoned Knife OOR") and isValidUnit("target") and not stealth and #enemies.yards10 == 0 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if ((buff.deadlyPoison.exists() and debuff.deadlyPoison.exists("thisUnit") and debuff.deadlyPoison.remain(thisUnit) <= gcd*2.5)
                        or (buff.agonizingPoison.exists() and debuff.agonizingPoison.exists("thisUnit") and debuff.agonizingPoison.stack(thisUnit) >= 5 and debuff.agonizingPoison.remain(thisUnit) <= gcd*2.5)) then
                           if cast.poisonedKnife(thisUnit) then return end
                        end
                    end
                end
                if isChecked("Poisoned Knife OOR") and isValidUnit("target") and not stealth and (#enemies.yards10 == 0 and powerTTM <= gcd) then
                    if cast.poisonedKnife("target") then return end
                end
            end            
        end -- End In Combat
    end -- End Profile
end -- runRotation
local id = 259
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})