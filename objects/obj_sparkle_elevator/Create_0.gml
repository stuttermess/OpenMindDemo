heads_sf = surface_create(480, 270);
xfrom = 240;
yfrom = 153;
zfrom = 6;
xto = 240;
yto = -50;
zto = 6;
fov = 60;
z = 0;
matrix_set(2, matrix_build_identity());

ani_door_open = function()
{
    smf_instance_play_animation(doorOpen, "animDoorOpen", 0.005, 1, false);
};

ani_zoom_in = function()
{
    zoomin_time = 0;
    do_zoomin = true;
};

zoom_ystart = yfrom;
zoom_yend = 141;
zoomin_time = 0;
zoomin_length = 60;
do_zoomin = false;

easeInBack = function(arg0)
{
    var c1 = 1.70158;
    var c3 = c1 + 1;
    return (c3 * arg0 * arg0 * arg0) - (c1 * arg0 * arg0);
};

animtimer = 0;
speakermodel = smf_model_load_obj("models/Elevators/Sparkle/SparkleElevatorSpeakers.obj");
speakermodel.texPack = [spr_sparkle_elevator_speaker];
speaker = new smf_instance(speakermodel);
model = smf_model_load_obj("models/Elevators/Sparkle/SparkleElevator.obj");
model.texPack = [spr_sparkle_elevator_base, spr_purple];
elevator = new smf_instance(model);
doormodel = smf_model_load_obj("models/Elevators/Sparkle/SparkleElevatorDoor.obj");
doormodel.texPack = [spr_sparkle_elevator_speaker, spr_purple];
door = new smf_instance(doormodel);
doormodel = smf_model_load_obj("models/Elevators/Sparkle/SparkleElevatorDoor.obj");
doormodel.texPack = [spr_sparkle_elevator_speaker, spr_purple];
door = new smf_instance(doormodel);
bunnymodel = smf_model_load_obj("models/Elevators/Sparkle/SparkleElevatorBunny.obj");
bunnymodel.texPack = [spr_sparkle_elevator_bunny, spr_purple];
bunny = new smf_instance(bunnymodel);
doorOpen = new smf_instance(smf_model_load("models/Elevators/Sparkle/SparkleElevatorDoorOpen.smf"));
smf_instance_enable_fast_sampling(doorOpen, false);
ear = new smf_instance(smf_model_load("models/Elevators/Sparkle/SparkleElevatorEar.smf"));
smf_instance_play_animation(ear, "anim_L_ear", 0.005, 1, true);
smf_instance_enable_fast_sampling(ear, false);
