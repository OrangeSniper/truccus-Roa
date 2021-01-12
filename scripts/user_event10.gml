// Muno template - [PHONE] update

// DO NOT EDIT - Only edit user_event15.gml



if (object_index == asset_get("obj_stage_article") || (object_index == oPlayer && phone_practice && phone.stage_id == noone)){
	with phone_user_id content();
}



#define content

// Print Debug phone setting

if phone.phone_settings[phone.setting_print_debug]{
	print_debug("CUSTOM 1           " + string(phone_custom_debug[0]));
	print_debug("CUSTOM 2           " + string(phone_custom_debug[1]));
	print_debug("CUSTOM 3           " + string(phone_custom_debug[2]));
	print_debug("HITPAUSE           " + string(hitstop));
	print_debug("STATE               " + get_state_name(state));
	print_debug("PREV STATE         " + get_state_name(prev_state));
	print_debug("PREV PREV STATE   " + get_state_name(prev_prev_state));
	print_debug("STATE TMR          " + string(state_timer));
	print_debug("ATTACK              " + string(attack));
	print_debug("WINDOW             " + string(window));
	print_debug("WINDOW TMR       " + string(window_timer));
	print_debug("SPR DIR             " + string(spr_dir));
	print_debug("HSP                  " + string(hsp));
	print_debug("VSP                  " + string(vsp));
	print_debug("FREE                 " + string(free));
	print_debug("FPS                  " + string(fps_real));
}



// Initially load frame data

if (phone_practice && !phone.frame_data_loaded) || (phone.state == 2 && phone.app == 4 && jump_pressed){
	loadFrameData();
	phone.frame_data_loaded = true;
	clear_button_buffer(PC_JUMP_PRESSED);
}



if phone_practice with phone{
	
	// Remove "Taunt!" hint
	
	if state && hint_opac > 0 hint_opac -= 0.1;
	
	
	
	// Display logic
	
	x = 10;
	
	var scrolled_left = (view_get_xview() + view_get_wview() * 0.5) < (other.room_width / 2 - 4);
	
	scrolled_left = true; // make it ALWAYS fade when lowered
	
	image_alpha = lerp(image_alpha, 1 - 0.5 * (scrolled_left && !(other.phone_attacking && other.attack == other.AT_PHONE)), 0.25);
	
	switch(state){
		
		case 0: // Hidden
			image_alpha = 0.5;
			y = 600;
			app = 0;
			cursor = 0;
			
			if turn_off player_id.phone_practice = false;
			break;
			
		case 1: // Opening
			var s_t_max = 20;
			
			if (state_timer == 1){
				with player_id sound_play(sfx_pho_open2);
			}
			
			y = ease_backOut(low_y, top_y, state_timer, s_t_max, 1);
			
			if (state_timer >= s_t_max){
				y = top_y;
				setState(2);
			}
			break;
		
		case 2: // Open
			
			if (other.shield_pressed || other.taunt_pressed){
				setState(4);
				with player_id sound_play(sfx_pho_close1);
			}
			if (other.special_pressed){
				if selected{
					selected = false;
					if app != 7 with player_id sound_play(sfx_pho_close2);
				}
				else if app app = 0;
				else{
					setState(3);
					with player_id sound_play(sfx_pho_close2);
				}
				with player_id clear_button_buffer(PC_SPECIAL_PRESSED);
			}
			
			
			
			// App control logic
					
			side_bar.should_open = 1;
			
			switch(app){
				
				case 0: // HOME Menu
				
					var select = homeMenuLogic();
					
					// don't allow app selection if that app's array is empty
					if select switch select{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 8:
							if array_equals(apps[select].array, []){
								select = 0;
								with player_id sound_play(sound_get("AAAAAAAAAA"));
							}
							break;
					}
					
					if select app = select;
					
					side_bar.should_open = 0;
					
					if (select == 7 && player_id.muno_char_id == 1){
						player_id.load_codecs = true;
					}
					
					break;
					
				case 1: // Tips
				case 2: // Patch Notes
				case 8: // About
				
					if selected{
						if side_bar.scroll_amt sideBarScrollLogic();
						if side_bar.scroll_amt_h sideBarScrollLogicH();
					}
					
					else{
						var select = normalListLogic(apps[app].array);
					
						if (select != -1){
							selected = true;
							with player_id sound_play(sfx_pho_select1);
						}
					}
					
					break;
					
				case 3: // Settings
				case 5: // Cheats
				case 6: // Stage
				
					if selected{
						if (array_length_1d(apps[app].array[cursor].options) > 1) sideBarOptionLogic(apps[app].array);
					}
					
					else{
						var select = normalListLogic(apps[app].array);
					
						if (select != -1) {
							if (array_length_1d(apps[app].array[cursor].options) > 1) selected = true;
							else setState(4);
							with player_id sound_play(sfx_pho_select1);
							if (app == 6) obj_stage_main.setting_clicked = select;
						}
					}
					
					break;
				
				case 4: // Frame Data
				
					if selected{
						if side_bar.scroll_amt sideBarScrollLogic();
						if side_bar.scroll_amt_h sideBarScrollLogicH();
					}
					
					else{
						var select = normalListLogic(apps[app].array);
					
						if (select != -1){
							selected = true;
							with player_id sound_play(sfx_pho_select1);
						}
					}
					
					break;
				
				case 7: // Codecs
					
					side_bar.should_open = 0;
					
					switch(player_id.muno_char_id){
						case 1:
						
							if (array_length_1d(player_id.codec_handler.active_codecs)){
								
								if !player_id.codec_handler.state selected = false;
								
								if selected{
									codecControlLogic();
									if player_id.codec_handler.state == 4 selected = false;
								}
								
								else{
									var select = normalListLogic(player_id.codec_handler.active_codecs);
								
									if (select != -1){
										selected = true;
										with player_id.codec_handler{
											setState(1);
											file = active_codecs[other.cursor];
										}
										with player_id sound_play(sfx_pho_select1);
									}
									else{
										with player_id.codec_handler if state == 3 || state == 2 setState(4);
									}
								}
								
							}
							
						break;
					}
				
					
					
					break;
				
				case 9: // Power off
					
					side_bar.should_open = 0;
					
					if player_id.attack_pressed{
						turn_off = true;
						state = 3;
						state_timer = 0;
						with player_id sound_play(sfx_pho_select1);
			
						with player_id clear_button_buffer(PC_ATTACK_PRESSED);
					}
				
			}
			
			break;
		
		case 3: // Closing
			var s_t_max = 20;
			
			y = ease_backIn(top_y, low_y, state_timer, s_t_max, 1);
			
			if (state_timer >= s_t_max){
				y = low_y;
				setState(0);
			}
			break;
		
		case 4: // Lowering
			var s_t_max = 20;
			
			y = ease_backInOut(top_y, (stage_id != noone) ? low_y : mid_y, state_timer, s_t_max, 1);
			
			if (state_timer >= s_t_max){
				y = (stage_id != noone) ? low_y : mid_y;
				setState(5);
			}
			break;
		
		case 5: // Low
			break;
		
		case 6: // Rising
			var s_t_max = 20;
			
			if (state_timer == 1){
				with player_id sound_play(sfx_pho_open1);
			}
			
			y = ease_backInOut((stage_id != noone) ? low_y : mid_y, top_y, state_timer, s_t_max, 1);
			
			if (state_timer >= s_t_max){
				y = top_y;
				setState(2);
			}
			break;
			
	}
	
	
	
	if phone_settings[setting_fast_graphics] image_alpha = 1;
	
	
	
	// Side bar logic
	
	with (side_bar){
		
		if scroll_y != scroll_y_target scroll_y = round(lerp(scroll_y, scroll_y_target, 0.5));
		if scroll_x != scroll_x_target scroll_x = round(lerp(scroll_x, scroll_x_target, 0.5));
		
		if (other.stage_id == noone){
			x = other.x + 106;
			y = other.y - 216;
			image_alpha = other.image_alpha;
		}
		
		switch(state){
			
			case 0: // Closed
			
				image_index = 0;
				if (other.state != 0 && (other.state != 5 || other.stage_id != noone) && should_open) setState(1);
				break;
			
			case 1: // Opening
			
				var s_t_max = 15;
				image_index = floor(ease_linear(1, 4, state_timer, s_t_max));
				if (state_timer == s_t_max) setState(2);
				break;
			
			case 2: // Open
			
				image_index = 4;
				if ((other.state != 2 && other.state != 1 && other.state != 6) || !should_open) && !(other.state != 0 && other.stage_id != noone && should_open) setState(3);
				if (other.selected != other.prev_selected) state_timer = 0;
				break;
			
			case 3: // Closing
			
				var s_t_max = 30;
				if (state_timer == s_t_max) setState(0);
				else image_index = floor(ease_linear(5, 11, state_timer, s_t_max));
				
				if ((other.state == 1 || other.state == 6 || other.state == 2) && should_open) setState(1);
				break;
			
		}
		
		state_timer++;
	}
	
	
	
	// End-of-frame housekeeping...
	
	state_timer++;
	
	if !((state == 0 || state == 5) && state_timer > 10){
	
		if (prev_app != app){
			if (app < prev_app){
				with player_id sound_play(sfx_pho_close2);
				cursor = prev_app - 1;
				scroll_y = 0;
				scroll_x = 0;
			}
			else{
				with player_id sound_play(sfx_pho_select1);
				cursor = 0;
			}
			app_timer = 5;
		}
		if app_timer app_timer--;
		
		if "codec_cursor_flag" not in self codec_cursor_flag = false;
		
		if (prev_cursor != cursor || prev_app != app || selected != prev_selected || (codec_cursor_flag == true)) {
			biggest_width = 0;
			cursor_timer = 5;
			prev_cursor_x = cursor_x;
			prev_cursor_y = cursor_y;
			prev_cursor_w = cursor_w;
			prev_cursor_h = cursor_h;
			with side_bar{
				scroll_x = 0;
				scroll_y = 0;
				scroll_x_target = 0;
				scroll_y_target = 0;
				last_scroll_dir = 0;
			}
			
			if (state == 2 && app == prev_app && selected == prev_selected) with player_id sound_play(sfx_pho_move);
			
			codec_cursor_flag = false;
		}
		if cursor_timer cursor_timer--;
		
		if cursor_timer_2 > 0 cursor_timer_2--;
		if cursor_timer_2 < 0 cursor_timer_2++;
		
		prev_cursor = cursor;
		prev_app = app;
		prev_state = state;
		prev_selected = selected;
	}
}



#define loadFrameData

with phone{

	i = 0; // i = current spot in the registered move list
	
	if include_stats initStats();
	if include_custom initCustomFD();
	
	for (j = 0; j < array_length_1d(move_ordering); j++){ // j = index in array of ordered attack indexes
		var current_attack_index = move_ordering[j];
		if (p_get_window_value(current_attack_index, 1, AG_WINDOW_LENGTH) || p_get_hitbox_value(current_attack_index, 1, HG_HITBOX_TYPE)) && !p_get_attack_value(current_attack_index, AG_MUNO_ATTACK_EXCLUDE){
			initMove(current_attack_index, move_names[current_attack_index]);
		}
	}
}



#define initStats

moves[i] = {
	name: "Stats",
	type: 1, // stats
	misc: stats_notes
};

i++;



#define initCustomFD

moves[i] = {
	name: custom_name,
	type: 3 // stats
};

i++;



#define initMove(atk_index, default_move_name)

var def = "-";

var stored_name = pullAttackValue(atk_index, AG_MUNO_ATTACK_NAME, default_move_name);

var stored_timeline = [];
if p_get_attack_value(atk_index, AG_MUNO_ATTACK_USES_ROLES) for (n = 0; p_get_window_value(atk_index, n+1, AG_WINDOW_LENGTH); n++){
	if p_get_window_value(atk_index, n+1, AG_MUNO_WINDOW_ROLE) stored_timeline[array_length_1d(stored_timeline)] = n+1;
}
else if p_get_attack_value(atk_index, AG_NUM_WINDOWS) for (n = 0; n < p_get_attack_value(atk_index, AG_NUM_WINDOWS); n++){
	if !(p_get_window_value(atk_index, n+1, AG_MUNO_WINDOW_EXCLUDE) == 1) stored_timeline[array_length_1d(stored_timeline)] = n+1;
}
else{
	stored_timeline = 0;
}

var stored_length = def;
if is_array(stored_timeline){
	stored_length = 0;
	for (n = 0; n < array_length_1d(stored_timeline); n++){
		if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 2) stored_length += p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH);
	}
	var stored_length_w = 0;
	for (n = 0; n < array_length_1d(stored_timeline); n++){
		if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 3) stored_length_w += ceil(p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH) * (p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_HAS_WHIFFLAG) ? 1.5 : 1));
	}
	stored_length = decimalToString(stored_length) + ((stored_length == stored_length_w) ? "" : " (" + decimalToString(stored_length_w) + ")");
}

var stored_ending_lag = def;
if (is_array(stored_timeline)){
	var time_int = 0;
	var time_int_whiff = 0;
	if p_get_attack_value(atk_index, AG_MUNO_ATTACK_USES_ROLES){
		for (n = 0; n < array_length_1d(stored_timeline); n++){
			if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_ROLE) == 3){
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 2) time_int += p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH);
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 3) time_int_whiff += ceil(p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH) * (p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_HAS_WHIFFLAG) ? 1.5 : 1));
			}
		}
	}
	else{
		for (n = 0; n < array_length_1d(stored_timeline); n++){
			var last_hitbox_frame = 0;
			var test_me = 0;
			for (hh = 0; p_get_hitbox_value(atk_index, hh, HG_HITBOX_TYPE); hh++){
				if (p_get_hitbox_value(atk_index, hh, HG_WINDOW) == stored_timeline[n]){
					test_me = p_get_hitbox_value(atk_index, hh, HG_LIFETIME) + p_get_hitbox_value(atk_index, hh, HG_WINDOW_CREATION_FRAME);
					if p_get_hitbox_value(atk_index, hh, HG_HITBOX_TYPE) == 2 test_me = -1;
					if abs(test_me) > last_hitbox_frame last_hitbox_frame = test_me;
				}
			}
			if last_hitbox_frame > 0{
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 2) time_int = p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH) - last_hitbox_frame;
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 3) time_int_whiff = ceil(p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH) * (p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_HAS_WHIFFLAG) ? 1.5 : 1) - last_hitbox_frame);
			}
			else if last_hitbox_frame == -1{ // projectile
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 2) time_int = p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH);
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 3) time_int_whiff = ceil(p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH) * (p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_HAS_WHIFFLAG) ? 1.5 : 1));
			}
			else{
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 2) time_int += p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH);
				if (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_EXCLUDE) != 3) time_int_whiff += ceil(p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH) * (p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_HAS_WHIFFLAG) ? 1.5 : 1));
			}
		}
	}
	
	if time_int && decimalToString(time_int) != stored_length{
		stored_ending_lag = decimalToString(time_int);
		if time_int != time_int_whiff stored_ending_lag += " (" + decimalToString(time_int_whiff) + ")";
	}
}
stored_ending_lag = pullAttackValue(atk_index, AG_MUNO_ATTACK_ENDLAG, stored_ending_lag);

var stored_landing_lag = def;
if (p_get_attack_value(atk_index, AG_HAS_LANDING_LAG) && p_get_attack_value(atk_index, AG_CATEGORY) == 1){
	stored_landing_lag = decimalToString(p_get_attack_value(atk_index, AG_LANDING_LAG));
	if p_get_attack_value(atk_index, AG_LANDING_LAG) stored_landing_lag += " (" + decimalToString(ceil(p_get_attack_value(atk_index, AG_LANDING_LAG) * 1.5)) + ")";
}
stored_landing_lag = pullAttackValue(atk_index, AG_MUNO_ATTACK_LANDING_LAG, stored_landing_lag);

var stored_misc = def;

if (p_get_attack_value(atk_index, AG_STRONG_CHARGE_WINDOW) != 0){
	var found = false;
	var strong_charge_frame = 0;
	for (var iter = 0; iter < array_length(stored_timeline) && !found; iter++){
		strong_charge_frame += ceil(p_get_window_value(atk_index, stored_timeline[iter], AG_WINDOW_LENGTH) * (p_get_window_value(atk_index, stored_timeline[iter], AG_WINDOW_HAS_WHIFFLAG) ? 1.5 : 1));
		if stored_timeline[iter] == p_get_attack_value(atk_index, AG_STRONG_CHARGE_WINDOW) found = true;
	}
	if found stored_misc = checkAndAdd(stored_misc, "Charge frame: " + decimalToString(strong_charge_frame));
}
	
if is_array(stored_timeline){
	var total_frames = 0;
	for (n = 0; n < array_length_1d(stored_timeline); n++){
		var frames = string(total_frames + 1) + "-" + string(total_frames + p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH));
		switch (p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_INVUL)){
			case -1:
				stored_misc = checkAndAdd(stored_misc, "Invincible f" + frames);
				break;
			case -2:
				stored_misc = checkAndAdd(stored_misc, "Super Armor f" + frames);
				break;
			case 0:
				break;
			default:
				stored_misc = checkAndAdd(stored_misc, string(p_get_window_value(atk_index, stored_timeline[n], AG_MUNO_WINDOW_INVUL)) + " Soft Armor f" + frames);
				break;
		}
		total_frames += p_get_window_value(atk_index, stored_timeline[n], AG_WINDOW_LENGTH);
	}
}

if (p_get_attack_value(atk_index, AG_MUNO_ATTACK_COOLDOWN) != 0)
	stored_misc = checkAndAdd(stored_misc, "Cooldown: " + string(abs(p_get_attack_value(atk_index, AG_MUNO_ATTACK_COOLDOWN))) + "f" + ((p_get_attack_value(atk_index, AG_MUNO_ATTACK_COOLDOWN) > 0) ? "" : " until land/walljump/hit"));
if (p_get_attack_value(atk_index, AG_MUNO_ATTACK_MISC_ADD) != 0)
	stored_misc = checkAndAdd(stored_misc, p_get_attack_value(atk_index, AG_MUNO_ATTACK_MISC_ADD));
if (p_get_attack_value(atk_index, AG_MUNO_ATTACK_MISC) != 0)
	stored_misc = p_get_attack_value(atk_index, AG_MUNO_ATTACK_MISC);

moves[i] = {
	type: 2, // an actual move
	index: atk_index,
	name: stored_name,
	length: stored_length,
	ending_lag: stored_ending_lag,
	landing_lag: stored_landing_lag,
	hitboxes: [],
	num_hitboxes: p_get_num_hitboxes(atk_index),
	timeline: stored_timeline,
	misc: stored_misc
};

k = 0;

for (l = 1; p_get_hitbox_value(atk_index, l, HG_HITBOX_TYPE); l++){
	if !p_get_hitbox_value(atk_index, l, HG_MUNO_HITBOX_EXCLUDE) initHitbox(i, l);
}

i++;



#define pullAttackValue(move, index, def)

if is_string(p_get_attack_value(move, index)) return p_get_attack_value(move, index);
else return def;



#define initHitbox(move_index, index)

var def = "-";

current_move = move_index;

var atk_index = moves[move_index].index;
var move = moves[move_index];
var parent = p_get_hitbox_value(atk_index, index, HG_PARENT_HITBOX);

var stored_active = def;
if is_array(moves[i].timeline){
	var win = p_get_hitbox_value(atk_index, index, HG_WINDOW);
	var w_f = p_get_hitbox_value(atk_index, index, HG_WINDOW_CREATION_FRAME);
	var lif = p_get_hitbox_value(atk_index, index, HG_LIFETIME);
	var frames_before = 0;
	var has_found = false;
	for (n = 0; n < array_length_1d(moves[i].timeline) && !has_found; n++){
		if (win == moves[i].timeline[n]){
			frames_before += w_f;
			has_found = true;
		}
		else{
			frames_before += p_get_window_value(atk_index, moves[i].timeline[n], AG_WINDOW_LENGTH);
		}
	}
	if has_found{
		stored_active = decimalToString(frames_before + 1);
		if (lif > 1){
			stored_active += "-";
			if (p_get_hitbox_value(atk_index, index, HG_HITBOX_TYPE) == 1){
				stored_active += decimalToString(frames_before + lif);
			}
		}
	}
}
stored_active = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_ACTIVE, stored_active);

var stored_damage = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_DAMAGE, pullHitboxValue(atk_index, index, HG_DAMAGE, def));

var stored_base_kb = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_BKB, pullHitboxValue(atk_index, index, HG_BASE_KNOCKBACK, "0"));
if p_get_hitbox_value(atk_index, index, HG_FINAL_BASE_KNOCKBACK) stored_base_kb += "-" + decimalToString(p_get_hitbox_value(atk_index, index, HG_FINAL_BASE_KNOCKBACK));

var stored_kb_scale = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_KBG, pullHitboxValue(atk_index, index, HG_KNOCKBACK_SCALING, "0"));

var stored_angle = def;
if p_get_hitbox_value(atk_index, index, HG_BASE_KNOCKBACK) stored_angle = decimalToString(p_get_hitbox_value(atk_index, index, HG_ANGLE));
else if p_get_hitbox_value(atk_index, parent, HG_BASE_KNOCKBACK) stored_angle = decimalToString(p_get_hitbox_value(atk_index, parent, HG_ANGLE));
var flipper = max(p_get_hitbox_value(atk_index, index, HG_ANGLE_FLIPPER), p_get_hitbox_value(atk_index, parent, HG_ANGLE_FLIPPER));
if flipper stored_angle += "*";

var stored_priority = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_PRIORITY, pullHitboxValue(atk_index, index, HG_PRIORITY, (move.num_hitboxes > 1) ? "0" : def));

var stored_group = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_GROUP, pullHitboxValue(atk_index, index, HG_HITBOX_GROUP, (move.num_hitboxes > 1) ? "0" : def));

var stored_base_hitpause = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_BHP, pullHitboxValue(atk_index, index, HG_BASE_HITPAUSE, "0"));

var stored_hitpause_scale = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_HPG, pullHitboxValue(atk_index, index, HG_HITPAUSE_SCALING, "0"));

var flipper_desc = [
	"sends at the exact same angle every time",
	"sends away from the center of the user",
	"sends toward the center of the user",
	"horizontal KB sends away from the hitbox center",
	"horizontal KB sends toward the hitbox center",
	"horizontal KB is reversed",
	"horizontal KB sends away from the user",
	"horizontal KB sends toward the user",
	"sends away from the hitbox center",
	"sends toward the hitbox center",
	"sends along the user's movement direction"
];

var effect_desc = ["nothing", "burn", "burn consume", "burn stun", "wrap", "freeze", "mark", "???", "auto wrap", "polite", "poison", "plasma stun", "crouchable"];

var ground_desc = ["woag", "Hits only grounded enemies", "Hits only airborne enemies"];

var tech_desc = ["woag", "Untechable", "Hit enemy goes through platforms", "Untechable, doesn't bounce"];

var flinch_desc = ["woag", "Forces grounded foes to flinch", "Cannot force flinch", "Forces crouching opponents to flinch"];

var rock_desc = ["woag", "Throws rocks", "Ignores rocks"];

var stored_misc = def;
// if (parent && parent != index)
// 	stored_misc = checkAndAdd(stored_misc, "Parent: " + pullHitboxValue(atk_index, parent, HG_MUNO_HITBOX_NAME, ((p_get_hitbox_value(atk_index, parent, HG_HITBOX_TYPE) == 1) ? "Hitbox " : "Proj. ") + string(parent)));
if (flipper)
	stored_misc = checkAndAdd(stored_misc, "Flipper " + decimalToString(flipper) + " (" + flipper_desc[flipper] + ")");
if (pullHitboxValue(atk_index, index, HG_EFFECT, def) != def)
	stored_misc = checkAndAdd(stored_misc, "Effect " + decimalToString(p_get_hitbox_value(atk_index, index, HG_EFFECT)) + ((real(pullHitboxValue(atk_index, index, HG_EFFECT, def)) < array_length(effect_desc)) ? " (" + effect_desc[real(pullHitboxValue(atk_index, index, HG_EFFECT, def))] + ")" : " (Custom)"));
if (pullHitboxValue(atk_index, index, HG_EXTRA_HITPAUSE, def) != def)
	stored_misc = checkAndAdd(stored_misc, decimalToString(p_get_hitbox_value(atk_index, index, HG_EXTRA_HITPAUSE)) + " Extra Hitpause");
if (pullHitboxValue(atk_index, index, HG_GROUNDEDNESS, def) != def)
	stored_misc = checkAndAdd(stored_misc, ground_desc[real(pullHitboxValue(atk_index, index, HG_GROUNDEDNESS, def))]);
if (pullHitboxValue(atk_index, index, HG_IGNORES_PROJECTILES, def) != def)
	stored_misc = checkAndAdd(stored_misc, "Cannot break projectiles");
if (pullHitboxValue(atk_index, index, HG_HIT_LOCKOUT, def) != def)
	stored_misc = checkAndAdd(stored_misc, decimalToString(p_get_hitbox_value(atk_index, index, HG_HIT_LOCKOUT)) + "f Hit Lockout");
if (pullHitboxValue(atk_index, index, HG_EXTENDED_PARRY_STUN, def) != def)
	stored_misc = checkAndAdd(stored_misc, "Has extended parry stun");
if (pullHitboxValue(atk_index, index, HG_HITSTUN_MULTIPLIER, def) != def)
	stored_misc = checkAndAdd(stored_misc, decimalToString(p_get_hitbox_value(atk_index, index, HG_HITSTUN_MULTIPLIER)) + "x Hitstun");
if (pullHitboxValue(atk_index, index, HG_DRIFT_MULTIPLIER, def) != def)
	stored_misc = checkAndAdd(stored_misc, decimalToString(p_get_hitbox_value(atk_index, index, HG_DRIFT_MULTIPLIER)) + "x Drift");
if (pullHitboxValue(atk_index, index, HG_SDI_MULTIPLIER, def) != def)
	stored_misc = checkAndAdd(stored_misc, decimalToString(p_get_hitbox_value(atk_index, index, HG_SDI_MULTIPLIER)) + "x SDI");
if (pullHitboxValue(atk_index, index, HG_TECHABLE, def) != def)
	stored_misc = checkAndAdd(stored_misc, tech_desc[real(pullHitboxValue(atk_index, index, HG_TECHABLE, def))]);
if (pullHitboxValue(atk_index, index, HG_FORCE_FLINCH, def) != def)
	stored_misc = checkAndAdd(stored_misc, flinch_desc[real(pullHitboxValue(atk_index, index, HG_FORCE_FLINCH, def))]);
if (pullHitboxValue(atk_index, index, HG_THROWS_ROCK, def) != def)
	stored_misc = checkAndAdd(stored_misc, rock_desc[real(pullHitboxValue(atk_index, index, HG_THROWS_ROCK, def))]);
if (pullHitboxValue(atk_index, index, HG_PROJECTILE_PARRY_STUN, def) != def)
	stored_misc = checkAndAdd(stored_misc, "Has parry stun");
if (pullHitboxValue(atk_index, index, HG_PROJECTILE_DOES_NOT_REFLECT, def) != def)
	stored_misc = checkAndAdd(stored_misc, "Does not reflect on parry");
if (pullHitboxValue(atk_index, index, HG_PROJECTILE_IS_TRANSCENDENT, def) != def)
	stored_misc = checkAndAdd(stored_misc, "Transcendent");
if (pullHitboxValue(atk_index, index, HG_MUNO_OBJECT_LAUNCH_ANGLE, def) != def)
	stored_misc = checkAndAdd(stored_misc, decimalToString(p_get_hitbox_value(atk_index, index, HG_MUNO_OBJECT_LAUNCH_ANGLE)) + " Workshop Object launch angle");

if (p_get_hitbox_value(atk_index, index, HG_MUNO_HITBOX_MISC_ADD) != 0)
	stored_misc = checkAndAdd(stored_misc, p_get_hitbox_value(atk_index, index, HG_MUNO_HITBOX_MISC_ADD));
if (p_get_hitbox_value(atk_index, index, HG_MUNO_HITBOX_MISC) != 0)
	stored_misc = p_get_hitbox_value(atk_index, index, HG_MUNO_HITBOX_MISC);
	
// moved to bottom so archy can go wild with his naming algorithm
/*
Hitbox purpose can be generalized using the data they have, and having certain qualities.
Hitbox Naming Scheme:
Launcher-	Low KBG, high BKB, high angle
Sour	-	Low KBG, low BKB, higher angle, small size
Sweet	-	High KBG, high BKB, lower angle, small size
Linker	-	Very low KBG, low BKB, high angle
Finisher-	high KBG, high BKB, any angle, after Multihit
Kill	-	high KBG, high BKB
Spike	-	angle near -90
Juggle	-	Med KBG, Med BKB, angle near 90
Funny	-	angle near -45
*/
// var hbox_name = (p_get_hitbox_value(atk_index, index, HG_HITBOX_TYPE) == 1) ? "Hitbox " : "";
// var larg_bkb_thresh = 6;
// var smol_bkb_thresh = 4;
// var larg_kb_thresh = .8;
// var smol_kb_thresh = .4;
// var tiny_kb_thresh = .1;

// switch true { // optimisation
// 	default:
// 		var _ang_flipper = p_get_hitbox_value(atk_index, index, HG_ANGLE_FLIPPER);
// 		if _ang_flipper == 9 break;
// 		if _ang_flipper == 8 {
// 			hbox_name = "Push ";
// 			break;
// 		}
// 		if _ang_flipper == 1 {
// 			hbox_name = "Pull ";
// 			break;
// 		}
// 		if ((p_get_hitbox_value(atk_index, index, HG_ANGLE) + 45) % 360) < 30 {
// 			hbox_name = "Funny ";
// 			break;
// 		}
// 		if ((p_get_hitbox_value(atk_index, index, HG_ANGLE) + 90) % 360) < 30 {
// 			hbox_name = "Spike ";
// 			break;
// 		}
// 		if p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) <= .1 && p_get_hitbox_value(atk_index, index, HG_HITBOX_TYPE) == 1 {
// 			hbox_name = "Linker ";
// 			break;
// 		}
// 		if p_get_hitbox_value(atk_index, index, HG_WIDTH) < 16 && p_get_hitbox_value(atk_index, index, HG_HEIGHT) < 16 { //Sweet or Sour
// 			if p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) < smol_kb_thresh {
// 				hbox_name = "Sour ";
// 				break;
// 			}
// 			if p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) < larg_kb_thresh {
// 				hbox_name = "Sweet ";
// 				break;
// 			}
// 		} 
// 		if p_get_hitbox_value(atk_index, index, HG_BASE_KNOCKBACK) > larg_bkb_thresh && p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) < smol_kb_thresh {
// 			if p_get_hitbox_value(atk_index, index, HG_ANGLE) > 60 && p_get_hitbox_value(atk_index, index, HG_ANGLE) < 120 {
// 				hbox_name = "Launcher ";
// 				break;
// 			}
// 		}
// 		if p_get_attack_value(atk_index, AG_CATEGORY) != 0 && p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) >= .7 {
// 			if (abs(p_get_hitbox_value(atk_index, index, HG_ANGLE) - 90) < 30) {
// 				hbox_name = "Juggle ";
// 				break;
// 			} 
// 			hbox_name = "Carry ";
// 			break;
// 		}
// 		if p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) >= larg_kb_thresh {
// 			if (abs(p_get_hitbox_value(atk_index, index, HG_ANGLE) - 90) < 30) {
// 				hbox_name = "V. Kill ";
// 				break;
// 			}
// 			hbox_name = "H. Kill ";
// 			break;
// 		}
// 		if p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) <= smol_kb_thresh && p_get_hitbox_value(atk_index, index, HG_KNOCKBACK_SCALING) > 0 {
// 			hbox_name = "Combo ";
// 			break;
// 		}

// 		break;
// }

// hbox_name += string(index);
// var stored_name = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_NAME, ((p_get_hitbox_value(atk_index, index, HG_HITBOX_TYPE) == 1) ? "" : "Proj. ") + hbox_name);

var stored_name = pullHitboxValue(atk_index, index, HG_MUNO_HITBOX_NAME, ((p_get_hitbox_value(atk_index, index, HG_HITBOX_TYPE) == 1) ? "Hitbox " : "Proj. ") + string(index));



array_push(moves[current_move].hitboxes, {
	name: stored_name,
	active: stored_active,
	damage: stored_damage,
	base_kb: stored_base_kb,
	kb_scale: stored_kb_scale,
	angle: stored_angle,
	priority: stored_priority,
	group: stored_group,
	base_hitpause: stored_base_hitpause,
	hitpause_scale: stored_hitpause_scale,
	misc: stored_misc,
	parent_hbox: parent
});



#define pullHitboxValue(move, hbox, index, def)

if p_get_hitbox_value(move, hbox, HG_PARENT_HITBOX) != 0 switch(index){
	case HG_HITBOX_TYPE:
	case HG_WINDOW:
	case HG_WINDOW_CREATION_FRAME:
	case HG_LIFETIME:
	case HG_HITBOX_X:
	case HG_HITBOX_Y:
	case HG_HITBOX_GROUP:
		break;
	default:
		if index < 70 hbox = p_get_hitbox_value(move, hbox, HG_PARENT_HITBOX);
}

if p_get_hitbox_value(move, hbox, index) != 0 || is_string(p_get_hitbox_value(move, hbox, index)) return decimalToString(p_get_hitbox_value(move, hbox, index));
else return string(def);



#define checkAndAdd(orig, add)

if orig == "-" return decimalToString(add);
return decimalToString(orig) + "
" + decimalToString(add);

#define p_get_window_value(attack, window, index)

var ret = 0;
with phone.player_id ret = get_window_value(attack, window, index);
return ret;

#define p_get_attack_value(attack, index)

var ret = 0;
with phone.player_id ret = get_attack_value(attack, index);
return ret;

#define p_get_hitbox_value(attack, hitbox, index)

var ret = 0;
with phone.player_id ret = get_hitbox_value(attack, hitbox, index);
return ret;

#define p_get_num_hitboxes(attack)

var ret = 0;
with phone.player_id ret = get_num_hitboxes(attack);
return ret;



#define codecControlLogic()

if !player_id.codec_handler.active return;

var len = array_length_1d(player_id.codec_handler.file.pages);
var orig = player_id.codec_handler.page;

with player_id{
	if (!joy_pad_idle && "held_timer" in self){
		held_timer++;
		
		var held = held_timer > 24 && held_timer mod 5 == 0;
		
		if (down_pressed || (down_down && held)){
			other.player_id.codec_handler.page++;
		}
		
		if (up_pressed || (up_down && held)){
			other.player_id.codec_handler.page--;
		}
		
		other.player_id.codec_handler.page = menuLoop(other.player_id.codec_handler.page, 0, len - 1);
		
	}else{
		held_timer = 0;
	}
		
	if attack_pressed{
		if other.player_id.codec_handler.state == 3 other.player_id.codec_handler.page++;
		else{
			with other.player_id.codec_handler{
				setState(3);
				stored_text = file.pages[page].text;
			}
		}
		clear_button_buffer(PC_ATTACK_PRESSED);
	}
}

if player_id.codec_handler.page != orig{
	with player_id.codec_handler setState(2);
	player_id.codec_handler.stored_text = "";
	cursor_timer = 5;
	codec_cursor_flag = true;
}

with player_id.codec_handler if (page >= len){
	setState(4);
	page = len - 1;
	phone.selected = false;
}



#define sideBarOptionLogic(arr)

var opts = arr[cursor].options;

var len = array_length_1d(opts);

var change = 0;

with player_id{
	if (!joy_pad_idle && "held_timer" in self){
		held_timer++;
		
		var held = held_timer > 24 && held_timer mod 5 == 0;
		
		if (right_pressed || (right_down && held)){
			arr[other.cursor].on++;
			sound_play(sfx_pho_move);
			other.cursor_timer_2 = 5;
			change = true;
		}
		
		else if (left_pressed || (left_down && held)){
			arr[other.cursor].on--;
			sound_play(sfx_pho_move);
			other.cursor_timer_2 = -5;
			change = true;
		}
		
		if change{
			arr[other.cursor].on = menuLoop(arr[other.cursor].on, arr[0] == 0, len - 1);
		
			if (other.app == 5) phone_cheats[other.cursor] = opts[arr[other.cursor].on];
			else if (other.app == 3) with other phone_settings[cursor] = opts[arr[cursor].on];
			else if (other.app == 6){
				obj_stage_main.cur_settings[other.cursor] = opts[arr[other.cursor].on];
				obj_stage_main.setting_updated = other.cursor;
			}
			
			phone_fast = phone.phone_settings[phone.setting_fast_graphics]; // blatant spaghetti code
			
		}
		
	}else{
		held_timer = 0;
	}
}



#define sideBarScrollLogic

var orig = side_bar.scroll_y_target;

with player_id{
	if (!joy_pad_idle && "held_timer" in self){
		held_timer++;
		
		var held = held_timer > 24 && held_timer mod 5 == 0;
		var amt = 60;
		
		if (down_pressed || (down_down && held)){
			other.side_bar.scroll_y_target -= amt;
		}
		
		if (up_pressed || (up_down && held)){
			other.side_bar.scroll_y_target += amt;
		}
		
		with other.side_bar scroll_y_target = clamp(scroll_y_target, -scroll_amt, 0);
		
		if other.side_bar.scroll_y_target != orig{
			sound_play(sfx_pho_move);
			other.side_bar.last_scroll_dir = 0;
		}
		
	}else{
		held_timer = 0;
	}
}



#define sideBarScrollLogicH

var orig = side_bar.scroll_x_target;

with player_id{
	if (!joy_pad_idle && "held_timer" in self){
		held_timer++;
		
		var held = held_timer > 24 && held_timer mod 5 == 0;
		var amt = 60;
		
		if (right_pressed || (right_down && held)){
			other.side_bar.scroll_x_target -= amt;
		}
		
		if (left_pressed || (left_down && held)){
			other.side_bar.scroll_x_target += amt;
		}
		
		with other.side_bar scroll_x_target = clamp(scroll_x_target, -scroll_amt_h, 0);
		
		if other.side_bar.scroll_x_target != orig{
			sound_play(sfx_pho_move);
			other.side_bar.last_scroll_dir = 1;
		}
		
	}else{
		held_timer = 0;
	}
}



#define homeMenuLogic

var col = cursor % 3;
var row = floor(cursor / 3);

with player_id{
	if (!joy_pad_idle && "held_timer" in self){
		// held_timer++;
		
		var held = held_timer > 24 && held_timer mod 5 == 0;
		
		if (down_pressed || (down_down && held)){
			row++;
		}
		
		if (up_pressed || (up_down && held)){
			row--;
		}
		
		if (right_pressed || (right_down && held)){
			col++;
		}
		
		if (left_pressed || (left_down && held)){
			col--;
		}
		
		// row = menuLoop(row, 0, 2);
		// col = menuLoop(col, 0, 2);
		
		row = clamp(row, 0, 2);
		col = clamp(col, 0, 2);
		
	}else{
		held_timer = 0;
	}
	
}
	
cursor = col + row * 3;

if player_id.attack_pressed{
	with player_id clear_button_buffer(PC_ATTACK_PRESSED);
	return cursor + 1;
}

else return 0;



#define normalListLogic(arr)

var len = array_length_1d(arr);

if len == 0 return -1;

if (cursor == 0 && arr[0] == 0) cursor++;

with player_id{
	if (!joy_pad_idle && "held_timer" in self){
		held_timer++;
		
		var held = held_timer > 24 && held_timer mod 5 == 0;
		
		if (down_pressed || (down_down && held)){
			other.cursor++;
		}
		
		if (up_pressed || (up_down && held)){
			other.cursor--;
		}
		
		other.cursor = menuLoop(other.cursor, arr[0] == 0, len - 1);
		
	}else{
		held_timer = 0;
	}
}

if player_id.attack_pressed{
	with player_id clear_button_buffer(PC_ATTACK_PRESSED);
	return cursor;
}
return -1;



#define menuLoop(value, low, high)

if (value == low - 1){
	value = high;
}

else if (value == high + 1){
	value = low;
}

return value;



#define setState(new_state)

state = new_state;
state_timer = 0;



#define decimalToString(input)

if !is_number(input) return(string(input));

input = string(input);
var last_char = string_char_at(input, string_length(input));

if (string_length(input) > 2){
	var third_last_char = string_char_at(input, string_length(input) - 2);
	if (last_char == "0" && third_last_char == ".") input = string_delete(input, string_length(input), 1);
}

if (string_char_at(input, 1) == "0") input = string_delete(input, 1, 1);

return input;