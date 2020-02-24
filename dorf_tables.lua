-- dorf_tables has job distribution configurations, random number information for attributes generation, job configurations, profession configurations, dwarf types(ie. attributes/characteristic) configurations
-- usage: loaded by dwopit.lua
-- by josh cooper(cppcooper) [created: Dec. 2017 | last modified: 2020-02-21]
--@ module = true

local utils=require('utils')
local validArgs = utils.invert({
 'help',
 'list'
})
local args = utils.processArgs({...}, validArgs)

local help = [====[

dorf_tables
===========
Data tables for dwopit.lua.

Arguments:
    list [jobs|professions|types]

Examples
    # dorf_tables -list jobs
    # dorf_tables -list professions
    # dorf_tables -list types

-~~~~~~~~~~
The data tables defined are described below.

job_distributions:
    Defines thresholds for each column of distributions. The columns must
    add up to the values in the thresholds row for that column.
    Every other row references an entry in 'jobs'

jobs:
    Defines dwopit's nameable jobs. This is preferable to taking every
    profession and making a distribution that covers all 100+ profs.

    Each job is comprised of required professions, optional professions,
    probabilities for each optional profession, a 'max' number of
    optional professions, and a list of type(s) to apply to dwarves in
    the defined job.

professions:
    These are a subset of the professions DF has. All professions listed
    will match a profession dwarf fortress has built in, however not all
    the built-ins are defined here.

    Each profession is defined with a set of job skills, these match
    the skills built in to dwarf fortress. Each skill is given a value
    which represents the bonus a dwarf will get to this skill. The skills
    are added in a random order, with the first few receiving the highest
    values (excluding the bonus just mentioned). Thus the bonuses are to
    ensure a minimum threshold is passed for certain skills deemed
    critical to a profession.

    To see a full list of built-in professions and jobs you can run
    these commands:
    # devel/query -table df.profession -listkeys
    # devel/query -table df.job_skill -listkeys

types:
    These are a sort of archetype system for applying to dwarves. It
    primarily includes physical attributes, but can include skills as well.

    Each type has a probability of being applied to a dwarf just by pure
    luck - this is in addition to types applied by other means. Each type
    also has a list of attribute(s) each attribute has a attribute_level
    associated to it. Additionally each type may define a list of skills
    from the aforementioned job_skill listing, each skill is defined with
    a minimum value and maximum value, the given value is an evening
    distributed random number between these two numbers (inclusive).

-~~~~~~~~~~
    To see a full list of built-in professions and jobs you can run
    these commands:
    # devel/query -table df.profession -listkeys
    # devel/query -table df.job_skill -listkeys

]====]

if not args.list and not moduleMode then
    print(help)
    print("scripts/dorf_tables.lua is a content library; calling it does nothing.")
    do return end
else
    print("Loading data tables..")
end

-- p denotes probability, always.
local O = 0
job_distributions = {
    Thresholds      = { 7,  14, 21, 28, 30, 35, 42, 49, 56, 63, 70, 77, 80, 110, 1000 }, --Don't touch unless you wanna recalculate the distributions,
    _hauler         = { O,  1,  3,  3,  O,  3,  2,  O,  4,  1,  1,  4,  O,  10,  413; cur = 0; max = nil },
    _soldier        = { O,  1,  O,  O,  O,  1,  O,  1,  O,  1,  O,  O,  1,  4,   413; cur = 0; max = nil },
    Miner           = { 2,  1,  O,  O,  O,  1,  O,  O,  O,  O,  2,  O,  O,  O,   10;  cur = 0; max = nil },
    Admin           = { 1,  O,  O,  1,  O,  O,  O,  O,  O,  O,  O,  O,  O,  1,   2;   cur = 0; max = nil },
    General         = { O,  O,  O,  1,  O,  O,  O,  O,  O,  1,  O,  O,  O,  2,   1;   cur = 0; max = nil },
    Doctor          = { O,  1,  O,  O,  O,  O,  O,  O,  O,  O,  O,  O,  1,  1,   3;   cur = 0; max = nil },
    Architect       = { 1,  O,  O,  O,  O,  O,  1,  O,  O,  O,  O,  O,  O,  2,   5;   cur = 0; max = nil },

    Farmer          = { 1,  O,  O,  O,  O,  O,  1,  O,  1,  1,  O,  O,  O,  2,   2;   cur = 0; max = nil },
    Rancher         = { O,  1,  O,  O,  O,  O,  O,  O,  O,  1,  O,  O,  O,  O,   2;   cur = 0; max = nil },
    Brewer          = { 1,  O,  O,  O,  O,  O,  O,  O,  O,  1,  O,  O,  O,  1,   5;   cur = 0; max = nil },
    Woodworker      = { 1,  O,  O,  O,  O,  O,  O,  1,  O,  O,  O,  O,  O,  O,   2;   cur = 0; max = nil },
    Stoneworker     = { O,  1,  O,  O,  O,  O,  O,  1,  O,  O,  2,  O,  O,  O,   2;   cur = 0; max = nil },
    Smelter         = { O,  1,  O,  O,  O,  O,  1,  O,  O,  O,  O,  O,  O,  1,   2;   cur = 0; max = nil },
    Blacksmith      = { O,  O,  1,  O,  O,  O,  O,  O,  O,  O,  O,  1,  O,  1,   2;   cur = 0; max = nil },

    Artison         = { O,  O,  O,  1,  O,  O,  O,  2,  O,  O,  2,  2,  O,  3,   5;   cur = 0; max = nil },
    Jeweler         = { O,  O,  O,  O,  1,  O,  O,  1,  O,  O,  O,  O,  O,  1,   1;   cur = 0; max = nil },
    Textileworker   = { O,  O,  O,  O,  1,  O,  1,  O,  O,  O,  O,  O,  O,  O,   1;   cur = 0; max = nil },

    Hunter          = { O,  O,  1,  O,  O,  O,  O,  O,  1,  O,  O,  O,  O,  O,   2;   cur = 0; max = nil },
    Fisher          = { O,  O,  1,  O,  O,  O,  1,  O,  1,  O,  O,  O,  O,  O,   2;   cur = 0; max = nil },
    Butcher         = { O,  O,  1,  O,  O,  O,  O,  O,  O,  O,  O,  O,  O,  O,   2;   cur = 0; max = nil },

    Engineer        = { O,  O,  O,  1,  O,  O,  O,  1,  O,  1,  O,  O,  1,  1,   3;   cur = 0; max = nil }
}
--[[
Stat Rolling:
    ->Loop dwarf attributes (physical/mental)
        ->Loop attrib_levels randomly selecting elements
            -Roll(p) to apply the element
             *Apply element to attribute,
             *or don't.
        <-End Loop
    <-End Loop
    
    ->Loop dorf_profs.<prof>.types{}
        -Apply attribs{}
        -Apply skills{}
    <-End Loop

    ->Loop dorf_types
        -Roll(p) to apply type
         *Apply type,
         *or don't.
    <-End Loop

    This procedure allows low rolls to be improved. High rolls cannot be replaced, except by even higher rolls.
--]]


--probability is used for generating all dwarf stats, some jobs include dorf_types which will upgrade particular stats
attrib_levels = { -- prob,      avg,    std deviation
    incompetent =   {p=0.01,    100,    20},
    verybad =       {p=0.02,    250,    25},
    bad =           {p=0.04,    450,    30},
    average =       {p=0.21,    810,    60},
    good =          {p=0.28,    1350,   75},
    verygood =      {p=0.22,    1700,   42},
    superb =        {p=0.12,    1900,   88},
    amazing =       {p=0.06,    2900,   188},
    incredible =    {p=0.03,    3800,   242},
    unbelievable =  {p=0.01,    4829,   42}
}

--[[
dorf_jobs = {
    job = {
        required_professions, max_tertiary_professions,
        tertiary_professions,
        dorf_types
    }
    The value associated with the tertiary professions is both an enforced ratio maximum for a given job,
    and also the probability that the profession will be applied during the algorithm's execution.
}
--]]
jobs = {
    _hauler = {
        req={'STANDARD','STANDARD'}, max={1988},
        RECRUIT=0.2,
        types={'strong5','strong4','fast3','spaceaware3','social','social'}},
    _soldier = {
        req={'TRAINED_WAR','TRAINED_WAR'}, max={1988},
        STANDARD=1.0, RECRUIT=0.5,
        types={'strong6','strong5','fast3','spaceaware3','soldier','fighter','social','social'}},
    Miner = {
        req={'MINER'}, max={1},
        BREWER=0.2, STONEWORKER=0.12, ENGRAVER=0.333,
        types={'spaceaware3','strong3','fast3','resilient2','social'}},
    Admin = {
        req={'ADMINISTRATOR'}, max={4},
        TRADER=0.665, CLERK=0.65, ARCHITECT=0.5,
        types={'genius3','genius3','genius3','intuitive3','intuitive3','resilient2','leader','leader','leader','adaptable','fighter','social','social','social','social'}},
    General = {
        req={'RECRUIT','SIEGE_OPERATOR','SIEGE_ENGINEER'}, max={2},
        COOK=0.3333, MILLER=0.3333,
        types={'fast2','genius2','spaceaware2','resilient2','leader','soldier','fighter'}},
    Doctor = {
        req={'DOCTOR'}, max={4},
        DIAGNOSER=0.76666, BONE_SETTER=0.6667, SUTURER=0.63333, SURGEON=0.3333,
        types={'genius3','resilient2','intuitive2','strong1','aware','agile'}},
    Architect = {
        req={'ARCHITECT','MECHANIC'}, max={3},
        ENGINEER=0.355, METALSMITH=0.4335, MASON=0.75, CARPENTER=0.65,
        types={'genius3','creative2','fast1','strong1','spaceaware3'}},

    Farmer = {
        req={'PLANTER','FARMER'}, max={3},
        POTASH_MAKER=0.43333, MILLER=0.3333, BREWER=0.5, THRESHER=0.42,
        types={'fast3','strong1','spaceaware1','resilient1','intuitive1'}},
    Rancher = {
        req={'ANIMAL_CARETAKER','GELDER'}, max={6},
        SHEARER=0.775, MILKER=0.2333, CHEESE_MAKER=0.115, BUTCHER=0.399, TANNER=0.47333, ANIMAL_TRAINER=0.9711,
        types={'fast3','strong3','intuitive2','resilient2','spaceaware1'}},
    Brewer = {
        req={'BREWER'}, max={2},
        HERBALIST=0.3333, POTTER=0.1111, THRESHER=0.5,
        types={'fast2','buff','resilient1','genius1'}},
    Woodworker = {
        req={'WOODWORKER','WOODCUTTER'}, max={2},
        CARPENTER=0.7336, BOWYER=0.63333,
        types={'fast3','fast3','strong1','creative1','agile','fighter'}},
    Stoneworker = {
        req={'STONEWORKER','MASON'}, max={2},
        ENGRAVER=0.58, MECHANIC=0.66,
        types={'strong3','fast2','spaceaware1','creative1'}},
    Smelter = {
        req={'FURNACE_OPERATOR','WOOD_BURNER','POTASH_MAKER'}, max={1988},
        types={'fast2','strong1','resilient1'}},
    Blacksmith = {
        req={'BLACKSMITH'}, max={3},
        WEAPONSMITH=0.775, ARMORER=0.7, METALSMITH=0.66, BOWYER=0.33,
        types={'strong3','fast2','spaceaware1'}},

    Artison = {
        req={'CRAFTSMAN','ENGRAVER','WOODCRAFTER','STONECRAFTER'}, max={2},
        BONE_CARVER=0.66, POTTER=0.75, GLASSMAKER=0.5,
        types={'fast3','buff','creative2','social','artistic'}},
    Jeweler = {
        req={'JEWELER','GEM_CUTTER','GEM_SETTER'}, max={1988},
        types={'creative2','intuitive2','spaceaware2','genius1','artistic'}},
    Textileworker = {
        req={'WEAVER','SPINNER','CLOTHIER'}, max={3},
        THRESHER=0.75, LEATHERWORKER=0.5, DYER=0.5,
        types={'fast1','creative1','social','artistic'}},

    Hunter = {
        req={'HUNTER','RANGER'}, max={3},
        TRAPPER=0.622, TANNER=0.88, BUTCHER=0.377, COOK=0.5,
        types={'fast3','intuitive3','spaceaware3','resilient2','strong1'}},
    Fisher = {
        req={'FISHERMAN','COOK'}, max={1},
        HERBALIST=0.77,
        types={'fast2','fast2','fast2','intuitive2','spaceaware2','resilient2','social','buff'}},
    Butcher = {
        req={'BUTCHER'}, max={2},
        TRAPPER=0.5, TANNER=0.75, COOK=0.66, BONE_CARVER=0.55,
        types={'spaceaware1','buff','aware'}},

    Engineer = {
        req={'ENGINEER'}, max={7},
        SIEGE_ENGINEER=0.88, MECHANIC=0.88, CLERK=0.88, PUMP_OPERATOR=0.88, SIEGE_OPERATOR=0.88, FURNACE_OPERATOR=0.5, BREWER=0.5,
        types={'genius3','intuitive2','leader'}}
}

--[[
professions:
    devel/query -table df.profession -listkeys
skills:
    devel/query -table df.job_skill -listkeys
--]]

professions = {

--Basic Dwarfing
    STANDARD =          { skills = {SHIELD=1, SPEAKING=4, FLATTERY=1, COMEDY=1, WOOD_BURNING=-9, COOK=-9, DISSECT_FISH=-10, PROCESSFISH=-11, BITE=1, PRESSING=-10, SING_MUSIC=1, WRESTLING=1, GRASP_STRIKE=1, STANCE_STRIKE=1} },
    ADMINISTRATOR =     { skills = {RECORD_KEEPING=3, ORGANIZATION=2, APPRAISAL=1} },
    TRADER =            { skills = {APPRAISAL=5, NEGOTIATION=4, JUDGING_INTENT=3, LYING=2} },
    CLERK =             { skills = {RECORD_KEEPING=3, ORGANIZATION=3} },
    DOCTOR =            { skills = {DIAGNOSE=4, DRESS_WOUNDS=3, SET_BONE=2, SUTURE=1, CRUTCH_WALK=1} },
    ENGINEER =          { skills = {OPTICS_ENGINEER=3, FLUID_ENGINEER=3, MATHEMATICS=6, CRITICAL_THINKING=5, LOGIC=4, CHEMISTRY=3} },
    ARCHITECT =         { skills = {DESIGNBUILDING=5, MASONRY=4, CARPENTRY=1} },

--Resource Economy
    MINER =             { skills = {MINING=3} },
    WOODCUTTER =        { skills = {WOODCUTTING=3} },
    WOOD_BURNER =       { skills = {WOOD_BURNING=2} },
    FURNACE_OPERATOR =  { skills = {SMELT=4} },
    --Wood
    CARPENTER =         { skills = {CARPENTRY=3, DESIGNBUILDING=2} },
    WOODWORKER =        { skills = {CARPENTRY=3} },
    WOODCRAFTER =       { skills = {WOODCRAFT=3} },
    --Stone
    MASON =             { skills = {MASONRY=3, DESIGNBUILDING=2} },
    STONEWORKER =       { skills = {MASONRY=3, STONECRAFT=2} },
    STONECRAFTER =      { skills = {STONECRAFT=3, MASONRY=1} },
    --Metal
    METALSMITH =        { skills = {FORGE_FURNITURE=3, METALCRAFT=2} },
    BLACKSMITH =        { skills = {FORGE_WEAPON=4, FORGE_ARMOR=3} },

--Armory
    BOWYER =            { skills = {BOWYER=3} },
    WEAPONSMITH =       { skills = {FORGE_WEAPON=3} },
    ARMORER =           { skills = {FORGE_ARMOR=3} },

--Arts & Crafts & Dwarfism
    CRAFTSMAN =         { skills = {WOODCRAFT=2, STONECRAFT=2, METALCRAFT=2} },
    ENGRAVER =          { skills = {DETAILSTONE=5} },
    MECHANIC =          { skills = {MECHANICS=5} },

--Plants & Animals
    --Agriculture
    POTASH_MAKER =      { skills = {POTASH_MAKING=3} },
    PLANTER =           { skills = {PLANT=4, PROCESSPLANTS=3, POTASH_MAKING=2} },
    FARMER =            { skills = {PLANT=3, MILLING=3, HERBALISM=2, PROCESSPLANTS=2, POTASH_MAKING=1} },
    MILLER =            { skills = {MILLING=3} },
    HERBALIST =         { skills = {HERBALISM=3} },
    THRESHER =          { skills = {PROCESSPLANTS=3} },
    --Ranching
    ANIMAL_CARETAKER =  { skills = {ANIMALCARE=3, GELD=3, SHEARING=2, MILK=1, ANIMALTRAIN=1} },
    ANIMAL_TRAINER =    { skills = {ANIMALTRAIN=5} },
    GELDER =            { skills = {GELD=7} },
    MILKER =            { skills = {MILK=3} },
    SHEARER =           { skills = {SHEARING=3, SPINNING=2} },
    CHEESE_MAKER =      { skills = {CHEESEMAKING=3} },
    --Hunting & Fishing
    HUNTER =            { skills = {SNEAK=4, TRACKING=5, RANGED_COMBAT=3, CROSSBOW=1} },
    TRAPPER =           { skills = {TRAPPING=3} },
    FISHERMAN =         { skills = {FISH=5, DISSECT_FISH=2, PROCESSFISH=2} },
    FISHERY_WORKER =    { skills = {DISSECT_FISH=5, PROCESSFISH=5}},
    --Dead Thing Science
    BUTCHER =           { skills = {BUTCHER=3, TANNER=2, COOK=-5, GELD=-8} }, --the '-3' is not a typo, it is just to populate the field [for DwarfTherapist auto-assigning]
    TANNER =            { skills = {TANNER=3, LEATHERWORK=1} },
    BONE_CARVER =       { skills = {BONECARVE=7} },

--Textile & Clothing & Leather Industry
    SPINNER =           { skills = {SPINNING=4, SHEARING=3} },
    WEAVER =            { skills = {WEAVING=3, PROCESSPLANTS=2} },
    DYER =              { skills = {DYER=3} },
    CLOTHIER =          { skills = {CLOTHESMAKING=2, DYER=1} },
    LEATHERWORKER =     { skills = {LEATHERWORK=3, TANNER=1} },

--War
    RECRUIT =           { skills = {KNOWLEDGE_ACQUISITION=5, DISCIPLINE=3} },
    TRAINED_WAR =       { skills = {MILITARY_TACTICS=7, MELEE_COMBAT=5, RANGED_COMBAT=1, COORDINATION=3, CONCENTRATION=5, DISCIPLINE=5, SITUATIONAL_AWARENESS=4, ARMOR=3, SHIELD=3, DODGING=3, STANCE_STRIKE=3, GRASP_STRIKE=3, SIEGEOPERATE=1, AXE=3, SWORD=2, MACE=1, HAMMER=2, SPEAR=1, PIKE=2, CROSSBOW=2, BOW=1} },
    SIEGE_ENGINEER =    { skills = {SIEGECRAFT=3, SIEGEOPERATE=1} },
    SIEGE_OPERATOR =    { skills = {SIEGEOPERATE=3} },
    PUMP_OPERATOR =     { skills = {OPERATE_PUMP=3} },

--Other
    BREWER =            { skills = {BREWING=3} },
    RANGER =            { skills = {ANIMALCARE=3, ANIMALTRAIN=3, CROSSBOW=2, SNEAK=2, TRAPPING=2} },
    COOK =              { skills = {COOK=3} },

    JEWELER =           { skills = {APPRAISAL=3, ENCRUSTGEM=2, CUTGEM=1} },
    GEM_CUTTER =        { skills = {CUTGEM=3} },
    GEM_SETTER =        { skills = {ENCRUSTGEM=3} },

    DIAGNOSER =         { skills = {DIAGNOSE=5} },
    BONE_SETTER =       { skills = {SET_BONE=5} },
    SUTURER =           { skills = {SUTURE=5} },
    SURGEON =           { skills = {SURGERY=5, GELD=2} },

    GLASSMAKER =        { skills = {GLASSMAKER=7, POTTERY=5, GLAZING=5} },
    POTTER =            { skills = {POTTERY=7, GLASSMAKER=5, GLAZING=5} },
    GLAZER =            { skills = {GLAZING=7, GLASSMAKER=5, POTTERY=5} },

}

--probability is used for randomly applying types to any and all dwarves
types = {
    resilient1 = {
        p = 0.2,
        attribs = {ENDURANCE={'verygood'},RECUPERATION={'verygood'},DISEASE_RESISTANCE={'superb'}}},
    resilient2 = {
        p = 0.05,
        attribs = {ENDURANCE={'amazing'},RECUPERATION={'incredible'},DISEASE_RESISTANCE={'unbelievable'}}},
    genius1 = {
        p = 0.1,
        attribs = {ANALYTICAL_ABILITY={'good'},FOCUS={'verygood'},INTUITION={'good'}}},
    genius2 = {
        p = 0.01,
        attribs = {ANALYTICAL_ABILITY={'superb'},FOCUS={'superb'},INTUITION={'superb'}}},
    genius3 = {
        p = 0.001,
        attribs = {ANALYTICAL_ABILITY={'unbelievable'},FOCUS={'amazing'},INTUITION={'amazing'}}},
    buff = {
        p = 0.1111,
        attribs = {STRENGTH={'good'},TOUGHNESS={'good'},WILLPOWER={'average'}}},
    fast1 = {
        p = 0.32,
        attribs = {AGILITY={'good'}}},
    fast2 = {
        p = 0.16,
        attribs = {AGILITY={'superb'}}},
    fast3 = {
        p = 0.08,
        attribs = {AGILITY={'incredible'}}},
    strong0 = {
        p = 0.16,
        attribs = {STRENGTH={'bad'},TOUGHNESS={'bad'},WILLPOWER={'average'}}},
    strong1 = {
        p = 0.5,
        attribs = {STRENGTH={'average'},TOUGHNESS={'average'},WILLPOWER={'good'}}},
    strong2 = {
        p = 0.2,
        attribs = {STRENGTH={'good'},TOUGHNESS={'verygood'},WILLPOWER={'verygood'}}},
    strong3 = {
        p = 0.1,
        attribs = {STRENGTH={'verygood'},TOUGHNESS={'superb'},WILLPOWER={'verygood'}}},
    strong4 = {
        p = 0.08,
        attribs = {STRENGTH={'superb'},TOUGHNESS={'superb'},WILLPOWER={'verygood'}}},
    strong5 = {
        p = 0.04,
        attribs = {STRENGTH={'amazing'},TOUGHNESS={'superb'},WILLPOWER={'superb'}}},
    strong6 = {
        p = 0.02,
        attribs = {STRENGTH={'incredible'},TOUGHNESS={'amazing'},WILLPOWER={'superb'}}},
    strong7 = {
        p = 0.01,
        attribs = {STRENGTH={'unbelievable'},TOUGHNESS={'amazing'},WILLPOWER={'amazing'}}},
    creative1 = {
        p = 0.05,
        attribs = {CREATIVITY={'superb'}}},
    creative2 = {
        p = 0.0159,
        attribs = {CREATIVITY={'incredible'}}},
    intuitive1 = {
        p = 0.3111,
        attribs = {INTUITION={'superb'}}},
    intuitive2 = {
        p = 0.2333,
        attribs = {INTUITION={'amazing'}}},
    intuitive3 = {
        p = 0.0777,
        attribs = {INTUITION={'unbelievable'}}},
    spaceaware1 = {
        p = 0.3333,
        attribs = {KINESTHETIC_SENSE={'good'},SPATIAL_SENSE={'verygood'}}},
    spaceaware2 = {
        p = 0.2222,
        attribs = {KINESTHETIC_SENSE={'verygood'},SPATIAL_SENSE={'amazing'}}},
    spaceaware3 = {
        p = 0.1111,
        attribs = {KINESTHETIC_SENSE={'amazing'},SPATIAL_SENSE={'unbelievable'}}},
        
--with skills
    agile = {
        p = 0.1111,
        attribs = {AGILITY={'amazing'}},
        skills  = {DODGING={7,14}}},
    aware = {
        p = 0.1111,
        attribs = {SOCIAL_AWARENESS={'superb'},KINESTHETIC_SENSE={'verygood'},SPATIAL_SENSE={'amazing'}},
        skills  = {SITUATIONAL_AWARENESS={4,16},CONCENTRATION={5,10},MILITARY_TACTICS={3,11},DODGING={2,5}}},
    social = {
        p = 0.511,
        attribs = {LINGUISTIC_ABILITY={'superb'},SOCIAL_AWARENESS={'superb'},EMPATHY={'verygood'}},
        skills  = {JUDGING_INTENT={8,12},PACIFY={4,16},CONSOLE={4,16},PERSUASION={2,8},CONVERSATION={2,8},FLATTERY={2,8},COMEDY={3,9},SPEAKING={4,10},PROSE={3,6}}},
    artistic = {
        p = 0.0733,
        attribs = {CREATIVITY={'incredible'},MUSICALITY={'amazing'},EMPATHY={'superb'}},
        skills  = {POETRY={0,4},DANCE={0,4},MAKE_MUSIC={0,4},WRITING={0,4},PROSE={2,5},SING_MUSIC={2,5},PLAY_KEYBOARD_INSTRUMENT={2,5},PLAY_STRINGED_INSTRUMENT={2,5},PLAY_WIND_INSTRUMENT={2,5},PLAY_PERCUSSION_INSTRUMENT={2,5}}},
    leader = {
        p=0.14,
        attribs = {FOCUS={'superb'},ANALYTICAL_ABILITY={'amazing'},LINGUISTIC_ABILITY={'superb'},PATIENCE={'incredible'},MEMORY={'verygood'},INTUITION={'amazing'},SOCIAL_AWARENESS={'incredible'},RECUPERATION={'verygood'},DISEASE_RESISTANCE={'good'},CREATIVITY={'superb'}},
        skills  = {LEADERSHIP={7,19},ORGANIZATION={7,17},TEACHING={12,18},MILITARY_TACTICS={7,19}}},
    adaptable = {
        p = 0.667,
        attribs = {STRENGTH={'average'},AGILITY={'average'},ENDURANCE={'average'},RECUPERATION={'average'},FOCUS={'verygood'}},
        skills  = {DODGING={4,16},CLIMBING={4,16},SWIMMING={4,16},KNOWLEDGE_ACQUISITION={4,16}}},
    fighter = {
        p = 0.4242,
        attribs = {STRENGTH={'good'},AGILITY={'average'},ENDURANCE={'good'},RECUPERATION={'average'},FOCUS={'verygood'}},
        skills  = {DODGING={5,10},GRASP_STRIKE={5,10},STANCE_STRIKE={5,10},WRESTLING={5,10},SITUATIONAL_AWARENESS={5,10}}},
    soldier = {
        p = 0.3333,
        attribs = {STRENGTH={'verygood'},AGILITY={'verygood'},ENDURANCE={'verygood'},RECUPERATION={'verygood'},FOCUS={'superb'}},
        skills  = {DISCIPLINE={7,14},SITUATIONAL_AWARENESS={5,10},MELEE_COMBAT={4,6},RANGED_COMBAT={4,6},ARMOR={4,6},HAMMER={4,6},CROSSBOW={4,6},COORDINATION={4,6},BALANCE={4,6},MILITARY_TACTICS={5,8}}}
}

function ListFields(t)
    for k,_ in pairs(t) do
        print("  " .. tostring(k))
    end
end

if args.list then
    if args.list == "jobs" then
        ListFields(jobs)
    elseif args.list == "professions" then
        ListFields(professions)
    elseif args.list == "types" then
        ListFields(types)
    else
        print("invalid argument provided. valid arguments: 'jobs','professions','types'")
    end
end
