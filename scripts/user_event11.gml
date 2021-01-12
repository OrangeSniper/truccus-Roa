// Muno template - [PHONE] draw_hud

// DO NOT EDIT - Only edit user_event15.gml



if "phone_inited" not in self exit; // dont give the funny error message

if (object_index == asset_get("obj_stage_main") || (object_index == oPlayer && phone_practice && phone.stage_id == noone)){
	with phone_user_id drawHud();
}

if (object_index == asset_get("obj_stage_article") || (object_index == oPlayer && phone_practice && phone.stage_id == noone)){
	with phone_user_id drawScreen();
}



#define drawHud

// FPS warning

if (fps_real) < 60 && "setting_fps_warn" in phone && phone.phone_settings[phone.setting_fps_warn]{
	var txt = textDraw(32, 32, "fName", c_white, 100, 10000, fa_left, 1, false, 0, "Low FPS! (" + string(round(fps_real)) + ")", true);
	rectDraw(28, 29, txt[0] + 5, txt[1] - 4, c_black);
	textDraw(32, 32, "fName", c_white, 100, 10000, fa_left, 1, false, 1, "Low FPS! (" + string(round(fps_real)) + ")", false);
}



// prompt

if phone_online && get_gameplay_time() < 300 && get_gameplay_time() % 30 < 25 draw_debug_text(10, 96, "ONLINE: Press the zero key to enable Fast Graphics.");



// "Taunt!" prompt

if phone.hint_opac > 0{
	if ("taunt_hint_y" not in phone){
		phone.taunt_hint_y = 0;
		phone.shader = 0;
	}
	
	var height = temp_y - 11 + ease_backOut(100, 0, round(phone.hint_opac * 10), 20, 2);
	textDraw(temp_x + 42 + phone.taunt_hint_x, height + phone.taunt_hint_y, "fName", c_white, 100, 100, fa_right, 1, true, 1, "Taunt!", false);
	draw_sprite_ext(phone.spr_pho_compatibility_badges, 0, temp_x + 40 + phone.taunt_hint_x, height + phone.taunt_hint_y - 7, 1, 1, 0, c_white, 1);
}



if phone.state{
	
	// Draw cursor around selected foe when choosing codec
	
	with phone if (app == 7 && player_id.muno_char_id == 1 && !selected && array_length_1d(player_id.codec_handler.active_codecs)){
		var curs_x = 0;
		var curs_y = 0;
		var curs_w = 0;
		var curs_h = 0;
		
		with player_id.codec_handler.active_codecs[cursor].player_object{
			var true_x = x - view_get_xview();
			var true_y = y - view_get_yview();
			curs_x = true_x - 40;
			curs_y = true_y - char_height - 20;
			curs_w = 80;
			curs_h = char_height + 24;
			
		}
		var alp = draw_get_alpha();
		draw_set_alpha(0.25 * (sin(get_gameplay_time() / 10) / 2 + 0.5));
		rectDraw(curs_x + 4, curs_y + 4, curs_w - 9, curs_h - 9, c_white);
		draw_set_alpha(alp);
		codec_cursor_scroll_exempt = true;
		drawCursor(
			curs_x,
			curs_y,
			curs_w,
			curs_h
		);
	}
	
	
	
	// Draw phone
	
	if !(phone.stage_id != noone && phone.state == 5){
		if phone.shader with phone.player_id shader_start();
		drawObj(phone);
		if phone.shader with phone.player_id shader_end();
	
	
	
		// Draw pressed keypad buttons
		
		// if (phone.state == 2){
		// 	draw_set_alpha(0.25);
			
		// 	if (up_pressed || up_down)				rectDraw(phone.x + 102, phone.y + 212, 49, 13, c_black);
		// 	if (down_pressed || down_down)			rectDraw(phone.x + 106, phone.y + 248, 41, 15, c_black);
		// 	if (right_pressed || right_down)		rectDraw(phone.x + 150, phone.y + 230, 35, 19, c_black);
		// 	if (left_pressed || left_down)			rectDraw(phone.x +  68, phone.y + 230, 35, 19, c_black);
		// 	if (attack_pressed || attack_down)		rectDraw(phone.x + 104, phone.y + 228, 45, 17, c_black);
		// 	if (special_pressed || special_down)	rectDraw(phone.x +  72, phone.y + 250, 33, 13, c_black);
			
		// 	draw_set_alpha(1);
		// }
		
		
		
		
		
		
		
		// Draw main display
		
		with phone{
		
			origin_x = x + 68;
			origin_y = y + 28;
			
			var txt = "Quit MunoPhone";
			if app txt = "HOME Menu";
			if selected txt = apps[app].name;
			
			drawControls(origin_x - 40, origin_y - 104, "SPECIAL:
			   " + txt + "
			SHIELD or TAUNT:
			   Minimise");
		
			maskHeader();
			rectDraw(origin_x, origin_y, screen_w, screen_h, c_white);
			maskMidder();
			
			
			
			// Wallpaper
			
			draw_set_alpha(phone.image_alpha * 3 - 2); // to make it so the screen isn't hella opaque when minimised. maybe remove if colored bgs are important to preserve
			rectDraw(origin_x, origin_y, screen_w, screen_h, apps[app].color);
			draw_set_alpha(phone.image_alpha);
			
			if app_timer origin_y += round(ease_backIn(0, 100, app_timer, 10, 1));
			
			
			
			// App main screens
			
			switch(app){
				
				case 0:
					
					drawHomeMenu();
					
					break;
					
				case 7:
				
					switch(player_id.muno_char_id){
						
						case 1:
						
							if !array_length_1d(player_id.codec_handler.active_codecs){
								
								textDraw(origin_x + screen_w / 2 + 2, origin_y + screen_h / 2, "fName", c_white, 18, screen_w, fa_center, 1, true, phone.image_alpha, "No Valid Codecs", false);
								textDraw(origin_x + screen_w / 2 + 2, origin_y + screen_h / 2 + 50, "fName", apps[app].color, 18, screen_w, fa_center, 1, true, phone.image_alpha, "bruhm oment", false);
								
								break;
							}
						
							if selected{
								drawCodecControls();
							}
							else{
								drawNormalList(player_id.codec_handler.active_codecs);
							}
							
							break;
							
						default:
						
							var sin_thing = sin(cursor_timer / 6) * 4;
					
							var valign = draw_get_valign();
							draw_set_valign(fa_middle);
							
							var margin = 8;
							
							var draw_x = origin_x + screen_w / 2 + 2;
							var draw_y = origin_y + 10 + (screen_w - 10) / 2 - sin_thing;
							var draw_w = screen_w - margin * 3;
							
							var drawn = textDraw(draw_x, draw_y, "fName", c_white, 18, draw_w, fa_center, 1, true, phone.image_alpha, "Trummel-Only", true);
							if !selected changeCursor(draw_x - drawn[0] / 2 - 7, draw_y - drawn[1] / 2 - 4 + sin_thing, drawn[0] + 11, drawn[1] + 1);
							
							draw_set_valign(valign);
							
							textDraw(draw_x, origin_y + screen_h - 58, "fName", apps[app].color, 18, draw_w, fa_center, 1, true, phone.image_alpha, "This app is only for Trummel.", false);
							
							break;
							
					}
					
					break;
					
				case 9:
				
					var sin_thing = sin(cursor_timer / 6) * 4;
					
					var valign = draw_get_valign();
					draw_set_valign(fa_middle);
					
					var margin = 8;
					
					var draw_x = origin_x + screen_w / 2 + 2;
					var draw_y = origin_y + 10 + (screen_w - 10) / 2 - sin_thing;
					var draw_w = screen_w - margin * 3;
					
					var drawn = textDraw(draw_x, draw_y, "fName", c_white, 18, draw_w, fa_center, 1, true, phone.image_alpha, "Turn Off MunoPhone", true);
					if !selected changeCursor(draw_x - drawn[0] / 2 - 7, draw_y - drawn[1] / 2 - 4 + sin_thing, drawn[0] + 11, drawn[1] + 1);
					
					draw_set_valign(valign);
					
					textDraw(draw_x, origin_y + screen_h - 40, "fName", apps[app].color, 18, draw_w, fa_center, 1, true, phone.image_alpha, "Press F5 to re-enable.", false);
					
					break;
					
				case 6:
					
					if stage_id == noone{
						
						var sin_thing = sin(cursor_timer / 6) * 4;
						
						var valign = draw_get_valign();
						draw_set_valign(fa_middle);
						
						var margin = 8;
						
						var draw_x = origin_x + screen_w / 2 + 2;
						var draw_y = origin_y + 10 + (screen_w - 10) / 2 - sin_thing;
						var draw_w = screen_w - margin * 3;
						
						var drawn = textDraw(draw_x, draw_y, "fName", c_white, 18, draw_w, fa_center, 1, true, phone.image_alpha, "NOT CONNECTED", true);
						if !selected changeCursor(draw_x - drawn[0] / 2 - 7, draw_y - drawn[1] / 2 - 4 + sin_thing, drawn[0] + 11, drawn[1] + 1);
						
						draw_set_valign(valign);
						
						textDraw(draw_x, origin_y + screen_h - 40, "fName", apps[app].color, 18, draw_w, fa_center, 1, true, phone.image_alpha, "See big screen.", false);
						
						break;
						
					}
				
				default:
				
					drawNormalList(apps[app].array);
					
					break;
					
			}
			
			
			
			// Cursor
			
			if !(selected && app != 7) && !(app == 7 && player_id.muno_char_id == 1 && !array_length_1d(player_id.codec_handler.active_codecs) && !selected) drawCursor(
				ease_quartInOut(round(cursor_x), round(prev_cursor_x), cursor_timer, 6),
				ease_quartInOut(round(cursor_y), round(prev_cursor_y), cursor_timer, 6),
				ease_quartInOut(round(cursor_w), round(prev_cursor_w), cursor_timer, 6),
				ease_quartInOut(round(cursor_h), round(prev_cursor_h), cursor_timer, 6)
				);
			
			
			
			// Transition between apps
			
			if app_timer origin_y -= round(ease_backIn(0, 100, app_timer, 10, 1));
			
			
			
			// Top bar
			
			draw_sprite_ext(spr_pho_bar, 0, origin_x, origin_y, 1, 1, 0, c_white, phone.image_alpha);
			if !phone_settings[setting_fast_graphics] && phone.image_alpha > 0.75 drawClock(origin_x + 82, origin_y + 2, other.current_hour, other.current_minute, other.current_second);
			
			maskFooter();
			
		}
	}
	
}



#define drawScreen

if phone.state{
	
	// Draw side display
	
	if object_index == oPlayer && phone.shader shader_start();
	
	drawObj(phone.side_bar);
	
	if object_index == oPlayer && phone.shader shader_end();
	
	with phone if (side_bar.state == 2 && app){
		
		var sin_thing = sin(cursor_timer / 6) * 4;
		
		var margin = 8;
		var header_height = 40;
	
		origin_x = side_bar.x + 132 + margin;
		origin_y = side_bar.y + 10 + margin;
		
		
		
		// Header
		
		draw_sprite_ext(player_id.muno_char_icon, 0, origin_x, origin_y - 4, 2, 2, 0, c_white, 1);
		var txt = textDraw(origin_x + 36, origin_y + 7, "fName", apps[app].color, 20, side_bar.screen_w - 20, fa_left, 1, false, 1, other.muno_char_name + " > " + apps[app].name + " > ", true);
		
		var date_text = (app == 2) ? " - " + apps[app].array[cursor].date : "";
		
		switch(app){
			case 9:
				break;
			case 6:
				if stage_id == noone{
					textDraw(origin_x + 42 + txt[0], origin_y + 7 - sin_thing, "fName", c_white, 20, side_bar.screen_w - 20 - txt[0], fa_left, 1, false, 1, "Not Connected", false);
					break;
				}
			default:
				textDraw(origin_x + 42 + txt[0], origin_y + 7 - sin_thing, "fName", c_white, 20, side_bar.screen_w - 20 - txt[0], fa_left, 1, false, 1, apps[app].array[cursor].name + date_text, false);
				break;
		}
		
		rectDraw(origin_x + 6, origin_y + 32, side_bar.screen_w - 18 + (stage_id != noone) * 14, 1, apps[app].color);
		
		if (app == 4 && state == 2) textDraw(origin_x + side_bar.screen_w, origin_y + 7, "fName", c_gray, 1000, 1000, fa_right, 1, 0, 1, "JUMP: refresh", false);
		
		
		
		// Mask
		
		maskHeader();
		rectDraw(origin_x, origin_y + header_height, side_bar.screen_w, side_bar.screen_h - header_height, c_white);
		maskMidder();
		
		origin_x += side_bar.scroll_x;
		origin_y += side_bar.scroll_y + header_height;
		
		
		
		// Content
		
		side_bar.scroll_amt = 0;
		side_bar.scroll_amt_h = 0;
		
		
		
		if (state != 2 && state != 4 && stage_id != noone && stage_id.screen.low_fps = true){
			var draw_x = origin_x + 10 + (side_bar.screen_w - 20) * 0.5;
			var draw_y = origin_y + 10;
			textDraw(draw_x, draw_y, "fName", c_white, 100, 1000, fa_center, 1, 0, 1, "- Hidden due to Performance Considerations -", false)
			
		}
		
		else switch(app){
			case 1:
			case 2:
			case 8:
			
				drawFormattedText(apps[app].array, sin_thing, header_height);
				
				break;
				
			case 6:
			
				if stage_id == noone {
					
					var draw_x = origin_x + 10;
					var draw_y = origin_y + 10 - sin_thing * 2;
					var draw_text_width = side_bar.screen_w - 20;
					
					var tease_txt = textDraw(draw_x, draw_y, "fName", c_white, 20, draw_text_width, fa_left, 1, false, 1, "This app is for use with the Training Town stage - an enhanced training room with the ability to change to any base game platform layout. Characters with the MunoPhone (like this one) can access bonus features like a combo counter, greenscreen, and sound test.
					
					Download at tinyurl.com/muno-collection", true);
					
					var spr = 0;
					with player_id spr = sprite_get("_pho_stage_teaser");
					
					draw_sprite(spr, 0, draw_x + 21, draw_y + tease_txt[1]);
					break;
					
				}
			
			case 3:
			case 5:
			
				drawSideBarOptions(apps[app].array, sin_thing, header_height);
				
				break;
				
			case 4:
				
				drawFrameDataTable(apps[app].array, sin_thing, header_height);
				
				break;
		}
		
		origin_x -= side_bar.scroll_x;
		origin_y -= side_bar.scroll_y;
		
		
		
		// Scroll bar
		
		if (side_bar.scroll_amt){
		
			var bar_w = 1;
			var bar_h = round((side_bar.screen_h - header_height) * (side_bar.screen_h - header_height) / (side_bar.scroll_amt + side_bar.screen_h));
			var bar_x = origin_x + side_bar.screen_w - bar_w;
			var bar_y = ease_linear(round(origin_y), round(origin_y + side_bar.screen_h - bar_h - 2 - header_height), round(abs(side_bar.scroll_y)), round(side_bar.scroll_amt));
			
			rectDraw(bar_x, bar_y, bar_w, bar_h, selected ? c_white : c_gray);
			
			if selected && (!side_bar.scroll_amt_h || !side_bar.last_scroll_dir) changeCursor(bar_x - 4, bar_y - 4, bar_w + 9, bar_h + 9);
			
		}
		
		
		
		// Horizontal scroll bar
		
		if (side_bar.scroll_amt_h){
		
			var bar_w = round((side_bar.screen_w) * (side_bar.screen_w) / (side_bar.scroll_amt_h + side_bar.screen_w));
			var bar_h = 1;
			var bar_x = ease_linear(round(origin_x), round(origin_x + side_bar.screen_w - bar_w - 2), round(abs(side_bar.scroll_x)), round(side_bar.scroll_amt_h));
			var bar_y = origin_y + side_bar.screen_h - bar_h - header_height;
			
			rectDraw(bar_x, bar_y, bar_w, bar_h, selected ? c_white : c_gray);
			
			if selected && (!side_bar.scroll_amt || side_bar.last_scroll_dir) changeCursor(bar_x - 4, bar_y - 4, bar_w + 9, bar_h + 9);
			
		}
		
		
		
		maskFooter();
		
		// Cursor
		
		if selected drawCursor(
			ease_quartInOut(round(cursor_x), round(prev_cursor_x), cursor_timer, 6),
			ease_quartInOut(round(cursor_y), round(prev_cursor_y), cursor_timer, 6),
			ease_quartInOut(round(cursor_w), round(prev_cursor_w), cursor_timer, 6),
			ease_quartInOut(round(cursor_h), round(prev_cursor_h), cursor_timer, 6)
			);
		
	}
}
	


#define drawControls(x1, y1, text) // Draw the normal MunoPhone controls above the phone

draw_sprite_ext(spr_pho_roundtangle_small, 0, x1, y1, 1, 1, 0, c_white, phone.image_alpha * 1.5 - 0.75);

textDraw(x1 + 12, y1 + 10, "fName", c_white, 16, 300, fa_left, 1, false, phone.image_alpha * 2 - 1, text, false);



#define drawObj(obj) // Draw an object to the screen, as long as it has all of the proper image_ variables

draw_sprite_ext(obj.sprite_index, obj.image_index, obj.x, obj.y, obj.image_xscale, obj.image_yscale, obj.image_angle, obj.image_blend, obj.image_alpha);



#define drawClock(x1, y1, hr, mn, sc) // Draw the system clock

if !phone_settings[setting_military_time]{
	if hr > 12 hr -= 12;
	if hr == 0 hr = 12;
}

var digit_1 = floor(hr / 10);
var digit_2 = hr % 10;
var digit_3 = floor(mn / 10);
var digit_4 = mn % 10;

if digit_1 || phone_settings[setting_military_time]
draw_sprite(spr_pho_digits, digit_1, x1, y1);
draw_sprite(spr_pho_digits, digit_2, x1 + 8, y1);
draw_sprite(spr_pho_digits, digit_3, x1 + 20, y1);
draw_sprite(spr_pho_digits, digit_4, x1 + 28, y1);

if (sc % 2){
	rectDraw(x1 + 16, y1, 1, 1, make_color_rgb(38, 48, 58));
	rectDraw(x1 + 16, y1 + 4, 1, 1, make_color_rgb(38, 48, 58));
}



#define drawCodecControls() // Draw the codec control prompts to the phone screen

var sin_thing = sin(cursor_timer / 6) * 4;
	
var valign = draw_get_valign();
draw_set_valign(fa_middle);

var draw_x = origin_x + screen_w / 2 + 2;
var draw_y = origin_y + 32 - sin_thing;
var draw_w = screen_w;

var txt = "Pg. " + string(player_id.codec_handler.page + 1);

var drawn = textDraw(draw_x, draw_y, "fName", c_white, 18, draw_w, fa_center, 1, true, phone.image_alpha, txt, true);
changeCursor(draw_x - drawn[0] / 2 - 7, draw_y - drawn[1] / 2 - 4 + sin_thing, drawn[0] + 11, drawn[1] + 1);

draw_set_valign(valign);
var app_color = apps[app].color;
textDraw(draw_x, origin_y + screen_h - 76, "fName", app_color, 18, draw_w, fa_center, 1, state != 5, phone.image_alpha, "ATTACK: Next", false);
textDraw(draw_x, origin_y + screen_h - 58, "fName", app_color, 18, draw_w, fa_center, 1, state != 5, phone.image_alpha, "UP/DOWN: Scroll", false);
textDraw(draw_x, origin_y + screen_h - 36, "fName", app_color, 18, draw_w, fa_center, 1, state != 5, phone.image_alpha, "Minimise to
Auto-Scroll", false);



#define drawFrameDataTable(arr, sin_thing, header_height)

var move = arr[cursor];

table_x = origin_x + 10;
table_y = origin_y + 10 - sin_thing * 2;

biggest_height = 0;

var item_width = 60;
var wide_width = 70;
var huge_width = 80;

table_should_draw = true;
var app_color = apps[app].color;
switch(move.type){
	
	case 1: // Stats
		
		var draw_widths = [];
		
		draw_widths[1] = drawTableItem(app_color, 0, "Walk
		Speed")[0];
		draw_widths[2] = drawTableItem(app_color, 0, "Walk
		Accel")[0];
		draw_widths[3] = drawTableItem(app_color, 0, "Dash
		Speed")[0];
		draw_widths[4] = drawTableItem(app_color, 0, "Init Dash
		Speed")[0];
		draw_widths[5] = drawTableItem(app_color, 0, "Init Dash
		Time")[0];
		draw_widths[6] = drawTableItem(app_color, 0, "Ground
		Friction")[0];
		draw_widths[7] = drawTableItem(app_color, 0, "Wave
		Adj")[0];
		draw_widths[8] = drawTableItem(app_color, 0, "Wave
		Friction")[0];
		
		startNewTableRow();
		
		drawTableItem(c_white, draw_widths[1], decimalToString(player_id.walk_speed));
		drawTableItem(c_white, draw_widths[2], decimalToString(player_id.walk_accel));
		drawTableItem(c_white, draw_widths[3], decimalToString(player_id.dash_speed));
		drawTableItem(c_white, draw_widths[4], decimalToString(player_id.initial_dash_speed));
		drawTableItem(c_white, draw_widths[5], decimalToString(player_id.initial_dash_time));
		drawTableItem(c_white, draw_widths[6], decimalToString(player_id.ground_friction));
		drawTableItem(c_white, draw_widths[7], decimalToString(player_id.wave_land_adj));
		drawTableItem(c_white, draw_widths[8], decimalToString(player_id.wave_friction));
		
		table_y += biggest_height + 20;
		table_x = origin_x + 10;
		
		draw_widths[1] = drawTableItem(app_color, 0, "Max Air
		Speed")[0];
		draw_widths[2] = drawTableItem(app_color, 0, "Air
		Accel")[0];
		draw_widths[3] = drawTableItem(app_color, 0, "Pratfall
		Accel")[0];
		draw_widths[4] = drawTableItem(app_color, 0, "Air
		Friction")[0];
		draw_widths[5] = drawTableItem(app_color, 0, "Leave
		Ground Max")[0];
		draw_widths[6] = drawTableItem(app_color, 0, "Max Jump
		Speed")[0];
		draw_widths[7] = drawTableItem(app_color, 0, "DJump
		Change")[0];
		
		startNewTableRow();
		
		drawTableItem(c_white, draw_widths[1], decimalToString(player_id.air_max_speed));
		drawTableItem(c_white, draw_widths[2], decimalToString(player_id.air_accel));
		drawTableItem(c_white, draw_widths[3], decimalToString(player_id.prat_fall_accel));
		drawTableItem(c_white, draw_widths[4], decimalToString(player_id.air_friction));
		drawTableItem(c_white, draw_widths[5], decimalToString(player_id.leave_ground_max));
		drawTableItem(c_white, draw_widths[6], decimalToString(player_id.max_jump_hsp));
		drawTableItem(c_white, draw_widths[7], decimalToString(player_id.jump_change));
		
		table_y += biggest_height + 20;
		table_x = origin_x + 10;
		
		draw_widths[1] = drawTableItem(app_color, 0, "Fall
		Speed")[0];
		draw_widths[2] = drawTableItem(app_color, 0, "Fast
		Fall")[0];
		draw_widths[3] = drawTableItem(app_color, 0, "
		Gravity")[0];
		draw_widths[8] = drawTableItem(app_color, 0, "Hitstun
		Gravity")[0];
		draw_widths[4] = drawTableItem(app_color, 0, "Full
		Hop")[0];
		draw_widths[5] = drawTableItem(app_color, 0, "Short
		Hop")[0];
		draw_widths[6] = drawTableItem(app_color, 0, "
		DJump")[0];
		draw_widths[7] = drawTableItem(app_color, 0, "DJump
		Count")[0];
		draw_widths[9] = drawTableItem(app_color, 0, "Walljump
		HSP/VSP")[0];
		
		startNewTableRow();
		
		drawTableItem(c_white, draw_widths[1], decimalToString(player_id.max_fall));
		drawTableItem(c_white, draw_widths[2], decimalToString(player_id.fast_fall));
		drawTableItem(c_white, draw_widths[3], decimalToString(player_id.gravity_speed));
		drawTableItem(c_white, draw_widths[8], decimalToString(player_id.hitstun_grav));
		drawTableItem(c_white, draw_widths[4], decimalToString(player_id.jump_speed));
		drawTableItem(c_white, draw_widths[5], decimalToString(player_id.short_hop_speed));
		drawTableItem(c_white, draw_widths[6], decimalToString(player_id.djump_speed));
		drawTableItem(c_white, draw_widths[7], decimalToString(player_id.max_djumps));
		drawTableItem(c_white, draw_widths[9], decimalToString(player_id.walljump_hsp) + "/" + string(player_id.walljump_vsp));
		
		table_y += biggest_height + 20;
		table_x = origin_x + 10;
		
		draw_widths[1] = drawTableItem(app_color, 0, "Knockback
		Adj")[0];
		draw_widths[2] = drawTableItem(app_color, 0, "Prat Land
		Time")[0];
		draw_widths[3] = drawTableItem(app_color, 0, "Land
		Time")[0];
		draw_widths[4] = drawTableItem(app_color, 0, "Jumpsquat
		Time")[0];
		
		drawTableItem(app_color, 1000, "
		Notes");
		
		startNewTableRow();
		
		drawTableItem(c_white, draw_widths[1], decimalToString(player_id.knockback_adj));
		drawTableItem((player_id.prat_land_time == 3) ? c_red : c_white, draw_widths[2], decimalToString(player_id.prat_land_time));
		drawTableItem(c_white, draw_widths[3], decimalToString(player_id.land_time));
		drawTableItem(c_white, draw_widths[4], decimalToString(player_id.jump_start_time));
		
		drawTableItem(c_white, side_bar.screen_w - table_x + origin_x - 10, stats_notes);
		break;

	case 2: // Move
		
		drawTableItem(app_color, item_width, "Length (Whiff)");
		drawTableItem(app_color, item_width, "End Lag (Whiff)");
		drawTableItem(app_color, wide_width, "Land Lag (Whiff)");
		drawTableItem(app_color, wide_width, "
		Notes");
		
		startNewTableRow();
		
		drawTableItem(c_white, item_width, move.length);
		drawTableItem(c_white, item_width, move.ending_lag);
		drawTableItem(c_white, wide_width, move.landing_lag);
		drawTableItem(c_white, side_bar.screen_w - table_x + origin_x - 10, move.misc);
		
		table_y += biggest_height;
		
		if array_length_1d(move.hitboxes) > 0{
		
			table_y += 20;
			table_x = origin_x + 10;
							
			biggest_height = 0;
			biggest_width = 0;
			
			drawTableItem(app_color, huge_width, "Hitbox");
			
			var draw_widths = [];
			
			draw_widths[1] = drawTableItem(app_color, 0, "Active")[0];
			draw_widths[2] = drawTableItem(app_color, 0, "DMG")[0];
			draw_widths[3] = drawTableItem(app_color, 0, "BKB")[0];
			draw_widths[4] = drawTableItem(app_color, 0, "KBG")[0];
			draw_widths[5] = drawTableItem(app_color, 0, "Angle")[0];
			draw_widths[6] = drawTableItem(app_color, 0, "Pri.")[0];
			draw_widths[7] = drawTableItem(app_color, 0, "Gro.")[0];
			draw_widths[8] = drawTableItem(app_color, 0, "BHP")[0];
			draw_widths[9] = drawTableItem(app_color, 0, "HPG")[0];
			drawTableItem(app_color, 0, "Notes");
			
			for (i = 0; i < array_length_1d(move.hitboxes); i++){
			
				startNewTableRow();
				
				var hitbox = move.hitboxes[i];
				
				var par_col = hitbox.parent_hbox && hitbox.parent_hbox != i ? c_gray : c_white;
				
				drawTableItem(app_color, huge_width, hitbox.name);
				
				drawTableItem(c_white, draw_widths[1], hitbox.active);
				drawTableItem(par_col, draw_widths[2], hitbox.damage);
				drawTableItem(par_col, draw_widths[3], hitbox.base_kb);
				drawTableItem(par_col, draw_widths[4], hitbox.kb_scale);
				drawTableItem(par_col, draw_widths[5], hitbox.angle);
				drawTableItem(par_col, draw_widths[6], hitbox.priority);
				drawTableItem(c_white, draw_widths[7], hitbox.group);
				drawTableItem(par_col, draw_widths[8], hitbox.base_hitpause);
				drawTableItem(par_col, draw_widths[9], hitbox.hitpause_scale);
				var new = drawTableItem(c_white, side_bar.screen_w * 0.9, hitbox.misc);
				
				if (table_x - origin_x > biggest_width) biggest_width = table_x - origin_x;
			}
			
			table_y += biggest_height;
		
		}
		break;
		
	case 3: // Custom
		
		for (i = 0; i < array_length_1d(custom_fd_content); i++){
			table_x = origin_x + 10;
			biggest_height = 0;
			var cfd = custom_fd_content[i];
			switch(cfd.type){
				case 0: // Header
					drawTableItem(app_color, side_bar.screen_w, cfd.content);
					startNewTableRow();
					break;
				case 1: // Body
					table_y += drawTableItem(c_white, side_bar.screen_w, cfd.content)[1] + 20;
					break;
			}
		}
		break;
}

if (biggest_width > side_bar.screen_w) side_bar.scroll_amt_h = abs(biggest_width - side_bar.screen_w) + 20;

// table_y += 32;

if (table_y - origin_y > side_bar.screen_h - header_height) side_bar.scroll_amt = abs(table_y - origin_y - side_bar.screen_h + header_height * 2);



#define startNewTableRow()

table_y += biggest_height;

rectDraw(origin_x, table_y, 2000, 1, apps[app].color);

table_y += 10;
table_x = origin_x + 10;
				
biggest_height = 0;

table_should_draw = (table_y == min(table_y, origin_y - side_bar.scroll_y + side_bar.screen_h));



#define drawTableItem(col, width, txt)

if (col == c_white && txt == "-") col = c_gray;

if (col == c_red){
	var shake_x = 0;
	var shake_y = 0;
	shake_x = random_func(0, 4, true) - 2;
	shake_y = random_func(1, 4, true) - 2;
	var drawn = textDraw(table_x + shake_x, table_y + shake_y, "fName", col, 20, width ? width : 1000, fa_left, 1, false, table_should_draw, txt, true);
} else {
	var drawn = textDraw(table_x, table_y, "fName", col, 20, width ? width : 1000, fa_left, 1, false, table_should_draw, txt, true);
}

if !width width = drawn[0];

table_x += (width == side_bar.screen_w * 0.9) ? drawn[0] : width + 15;
if (biggest_height < drawn[1]) biggest_height = drawn[1];

return drawn;



#define drawSideBarOptions(arr, sin_thing, header_height)
				
var draw_x = origin_x + 10 + (side_bar.screen_w - 20) * 0.5;
var draw_y = origin_y + 10 - sin_thing * 2;
var para_margin = 10;
var sin_thing_2 = sin(abs(cursor_timer_2) / 6) * 4;

var header = textDraw(draw_x, draw_y, "fName", c_white, 20, side_bar.screen_w - 20, fa_center, 1, false, 1, "Current Option:", true);

draw_y += header[1] + para_margin;

var option_text = textDraw(draw_x, draw_y - sin_thing_2, "fName", c_white, 20, side_bar.screen_w - 20, fa_center, 1, false, 1, arr[cursor].option_names[arr[cursor].on], true);

if (biggest_width < option_text[0]) biggest_width = option_text[0];

if selected{
	changeCursor(draw_x - option_text[0] / 2 - 7, draw_y - 5 + sin_thing - sin_thing_2, option_text[0] + 11, option_text[1] + 1);
	draw_sprite_ext(spr_pho_arrow, 0, draw_x - biggest_width - 7, draw_y - (sin_thing_2 * (cursor_timer_2 < 0)), -1, 1, 0, (cursor_timer_2 < 0) ? c_white : c_gray, 1);
	draw_sprite_ext(spr_pho_arrow, 0, draw_x + biggest_width + 7, draw_y - (sin_thing_2 * (cursor_timer_2 > 0)),  1, 1, 0, (cursor_timer_2 > 0) ? c_white : c_gray, 1);
}

draw_y += option_text[1] + para_margin + 2;

var itm_wd = 8;
var mar = 2;
var itm_ct = array_length_1d(arr[cursor].options);
var tot_w = (itm_ct * itm_wd) + ((itm_ct - 1) * mar);
var starting_x_pos = draw_x - tot_w / 2 - 2;

if itm_ct == clamp(itm_ct, 2, 40) for(i = 0; i < itm_ct; i++){
    var draw_color = (i == arr[cursor].on) ? c_white : c_gray;
    var rect_x = starting_x_pos + (itm_wd + mar) * i;
    rectDraw(rect_x, draw_y - 10, 7, 3, draw_color);
}

rectDraw(origin_x + 6, draw_y, side_bar.screen_w - 18 + (stage_id != noone) * 14, 1, apps[app].color);

draw_y += para_margin * 2;

var desc_text = textDraw(draw_x, draw_y, "fName", c_white, 20, side_bar.screen_w - 20, fa_center, 1, false, 1, arr[cursor].description, true);



#define drawFormattedText(arr, sin_thing, header_height)

var draw_x = origin_x + 10;
var draw_y = origin_y + 10 - sin_thing * 2;
var para_margin = 10;
var last_drawn = [0, 0];
var stored_height = 0; // for side-by-side elements

var draw_y_init = draw_y;

for (i = 0; i < array_length_1d(arr[cursor].objs); i++){
	var cur = arr[cursor].objs[i];
	
	var offset_x = 0;
	var offset_y = 0;
	
	if cur.gimmick == 5 with player_id shader_start();
	
	if (cur.type == 0){ // Text
		
		var draw_text_width = side_bar.screen_w - 20;
		
		var true_ind = cur.indent * 32;
		
		switch(cur.align){
			case fa_left:
				offset_x += true_ind;
				draw_text_width -= true_ind;
				break;
			case fa_center:
				offset_x = (side_bar.screen_w - 20) * 0.5;
				break;
			case fa_right:
				offset_x = (side_bar.screen_w - 20) - true_ind;
				draw_text_width -= true_ind;
				break;
		}
		
		switch(cur.gimmick){
			case 1: // shaky ooooo
				offset_x += random_func(i + 0, 4, true) - 2;
				offset_y += random_func(i + 1, 4, true) - 2;
				break;
			case 2: // scrolling to the left
				offset_x += ease_linear(side_bar.screen_w, 0, side_bar.state_timer % 120, 120);
				break;
			case 3: // scrolling to the right
				offset_x -= ease_linear(side_bar.screen_w, 0, side_bar.state_timer % 120, 120);
				break;
			case 4: // don't increase scroll
				break;
		}
		
		last_drawn = textDraw(draw_x + offset_x, draw_y + offset_y, "fName", cur.color, 20, draw_text_width, cur.align, 1, false, 1, cur.text, true);
		
		switch(cur.gimmick){
			case 2:
			case 3:
				textDraw(draw_x + offset_x + side_bar.screen_w, draw_y + offset_y, "fName", cur.color, 20, draw_text_width, cur.align, 1, false, 1, cur.text, false);
				textDraw(draw_x + offset_x - side_bar.screen_w, draw_y + offset_y, "fName", cur.color, 20, draw_text_width, cur.align, 1, false, 1, cur.text, false);
				break;
			case 4:
				break;
		}
		
	}
	
	if (cur.type == 1){ // Images
		
		var x_off = sprite_get_xoffset(cur.sprite) * abs(cur.xscale);
		var y_off = sprite_get_yoffset(cur.sprite) * abs(cur.xscale);
		
		if cur.needs_auto_margins{
			if (cur.xscale == -1){
				cur.margin_l = x_off;
				cur.margin_r = sprite_get_width(cur.sprite) - x_off;
			}
			else{
				cur.margin_l = x_off;
				cur.margin_r = sprite_get_width(cur.sprite) - x_off;
			}
			cur.margin_u = y_off;
			cur.margin_d = sprite_get_height(cur.sprite) - y_off;
		}
		
		var draw_frame = cur.frame;
		
		if (draw_frame < 0){
			draw_frame = side_bar.state_timer / abs(draw_frame);
		}
		
		var draw_l = x_off - cur.margin_l;
		var draw_t = y_off - cur.margin_u;
		var draw_w = (x_off + cur.margin_r) - (x_off - cur.margin_l);
		var draw_h = (y_off + cur.margin_d) - (y_off - cur.margin_u);
		
		if sign(cur.xscale) == -1 draw_x += draw_w;
		
		switch(cur.align){
			case fa_left:
				offset_x = 0;
				break;
			case fa_center:
				offset_x = (side_bar.screen_w - 20) * 0.5 - draw_w * 0.5;
				break;
			case fa_right:
				offset_x = (side_bar.screen_w - 20) - draw_w;
				break;
		}
		
		switch(cur.gimmick){
			case 1: // shaky ooooo
				offset_x += random_func(i + 0, 4, true) - 2;
				offset_y += random_func(i + 1, 4, true) - 2;
				break;
			case 2: // scrolling to the left
				offset_x += ease_linear(side_bar.screen_w, 0, side_bar.state_timer % 120, 120);
				break;
			case 3: // scrolling to the right
				offset_x -= ease_linear(side_bar.screen_w, 0, side_bar.state_timer % 120, 120);
				break;
			case 4: // don't increase scroll
				break;
		}
		
		draw_sprite_part_ext(cur.sprite, draw_frame, draw_l, draw_t, draw_w, draw_h, draw_x + offset_x, draw_y + offset_y, cur.xscale, 1, cur.color, 1);
		switch(cur.gimmick){
			case 2:
			case 3:
				draw_sprite_part_ext(cur.sprite, draw_frame, draw_l, draw_t, draw_w, draw_h, draw_x + offset_x + side_bar.screen_w, draw_y + offset_y, cur.xscale, 1, cur.color, 1);
				draw_sprite_part_ext(cur.sprite, draw_frame, draw_l, draw_t, draw_w, draw_h, draw_x + offset_x - side_bar.screen_w, draw_y + offset_y, cur.xscale, 1, cur.color, 1);
				break;
			case 4:
				break;
		}
		
		last_drawn = [draw_w, draw_h];
	}
	
	var do_side_thing = (i < array_length_1d(arr[cursor].objs) - 1 && arr[cursor].objs[i+1].type == 1 && !cur.side_by_side_exempt && !arr[cursor].objs[i+1].side_by_side_exempt && !stored_height);
	
	
	if stored_height{
		last_drawn[1] = max(stored_height, last_drawn[1]);
		stored_height = 0;
	}
	
	if do_side_thing{
	
		var cur2 = arr[cursor].objs[i+1];
		
		if cur2.needs_auto_margins{
			cur2.margin_l = x_off;
			cur2.margin_r = sprite_get_width(cur2.sprite) - x_off;
			cur2.margin_u = y_off;
			cur2.margin_d = sprite_get_height(cur2.sprite) - y_off;
		}
		
		var aligns_check_out = (cur.align == fa_right && cur2.align == fa_left) || (cur.align == fa_left && cur2.align == fa_right);
		var widths_are_good = (last_drawn[0] + para_margin + cur2.margin_l + cur2.margin_r < side_bar.screen_w - 20);
		
		if (aligns_check_out && widths_are_good){
			draw_y -= last_drawn[1] + para_margin;
			stored_height = last_drawn[1];
		}
		
	}
	
	if cur.gimmick != 4 || i == array_length_1d(arr[cursor].objs) - 1 draw_y += last_drawn[1] + para_margin;
	
	if cur.gimmick == 5 with player_id shader_end();
}

draw_y -= draw_y_init;

if (draw_y > side_bar.screen_h - header_height) side_bar.scroll_amt = abs(draw_y - side_bar.screen_h + header_height * 2);



#define drawHomeMenu

var sin_thing = sin(cursor_timer / 6) * 4;

textDraw(origin_x + screen_w / 2 + 2, origin_y + 15 - sin_thing, "fName", c_white, 1000, 1000, fa_center, 1, true, phone.image_alpha, apps[cursor+1].name, false);

for (i = 0; i < array_length_1d(apps); i++){
	j = i - 1;
	
	var grid_space = 38;
	
	var off_x = 4 + grid_space * (j % 3);
	var off_y = 34 + grid_space * floor(j / 3);
	
	if (cursor == j){
		draw_sprite_ext(spr_pho_app_icons, apps[i].sprite, origin_x + off_x, origin_y + off_y, 1, 1, 0, c_black, phone.image_alpha);
		changeCursor(origin_x + off_x - 2, origin_y + off_y - 2, 38, 38);
		off_y -= 2;
	}
	
	var draw_color = (cursor == j) ? c_white : make_color_hsv(0, 0, 128);
	
	draw_sprite_ext(spr_pho_app_icons, apps[i].sprite, origin_x + off_x, origin_y + off_y, 1, 1, 0, draw_color, phone.image_alpha);
	if (i == 2){
		var draw_x = origin_x + off_x + 34;
		var draw_y = origin_y + off_y + 21;
		
		textDraw(draw_x, draw_y, "fName", draw_color, 1000, 1000, fa_right, 1, true, 1, "v" + string(get_char_info(player_id.player, INFO_VER_MAJOR)) + "." + string(get_char_info(player_id.player, INFO_VER_MINOR)), false);
	}
}



#define drawNormalList(arr)

if false && (phone_settings[setting_fast_graphics] || array_length_1d(arr) > 50 || (app == 4 && apps[app].array[cursor] == 2 && array_length_1d(apps[app].array[cursor].hitboxes) > 5)){
	
	var sin_thing = sin(cursor_timer / 6) * 4;
	
	var valign = draw_get_valign();
	draw_set_valign(fa_middle);
	
	var margin = 8;
	
	var draw_x = origin_x + screen_w / 2 + 2;
	var draw_y = origin_y + 10 + (screen_w - 10) / 2 - sin_thing;
	var draw_w = screen_w - margin * 3;
	
	var txt = "";
	if is_string(arr[cursor]) txt = arr[cursor];
	else txt = arr[cursor].name;
	
	var drawn = textDraw(draw_x, draw_y, "fName", c_white, 18, draw_w, fa_center, 1, true, phone.image_alpha, txt, true);
	if !selected changeCursor(draw_x - drawn[0] / 2 - 7, draw_y - drawn[1] / 2 - 4 + sin_thing, drawn[0] + 11, drawn[1] + 1);
	
	draw_set_valign(valign);
	
	textDraw(draw_x, origin_y + screen_h - 60, "fName", apps[app].color, 18, draw_w, fa_center, 1, true, phone.image_alpha, "Item " + string(cursor + !(arr[0] == 0)) + "/" + string(array_length_1d(arr) - (arr[0] == 0)), false);
	textDraw(draw_x, origin_y + screen_h - 40, "fName", apps[app].color, 18, draw_w, fa_center, 1, true, phone.image_alpha, "Press Up / Down", false);
	
}

else{
	
	var sin_thing = sin(cursor_timer / 6) * 4;
	
	var draw_y = origin_y + 15 + scroll_y;
	
	var total_height = 0;
	var start_height = origin_y + scroll_y;
	var end_height = 0;
	
	if array_length_1d(arr) for (var i = 0; i < array_length_1d(arr); i++){
		if (arr[i] == 0) i++;
		
		var crs = (cursor == i);
		
		var txt = "";
		if is_string(arr[i]) txt = arr[i];
		else txt = arr[i].name;
		
		var do_opac = (draw_y == clamp(draw_y, origin_y - 32, origin_y + screen_h));
		
		var drawn = textDraw(origin_x + 6, draw_y - crs * sin_thing, "fName", crs ? c_white : apps[app].dark_color, 18, screen_w - 6 * 3, fa_left, 1, false, do_opac, txt, true);
		
		if crs changeCursor(origin_x, draw_y - 5 + crs * sin_thing, drawn[0] + 10, drawn[1] + 1);
		end_height = draw_y - 5 + drawn[1] + 1;
		
		draw_y += drawn[1] + 2;
	}
	
	total_height = end_height - start_height;
	
	if total_height > screen_h{
		total_height -= screen_h;
		var bar_w = 1;
		var bar_h = round((screen_h - 14) * (screen_h - 14) / (total_height + screen_h - 14));
		var bar_x = origin_x + screen_w - bar_w;
		var bar_y = ease_linear(round(origin_y + 12), round(origin_y + screen_h - bar_h - 2), round(abs(scroll_y)), round(total_height));
		
		rectDraw(bar_x - 2, origin_y + 10, bar_w + 2, screen_h, c_black);
		rectDraw(bar_x, bar_y, bar_w, bar_h, c_white);
	}
	
}



#define drawCursor(x1, y1, w, h)

var x2 = x1 + w;
var y2 = y1 + h;

var col = c_white;

if "codec_cursor_scroll_exempt" not in self codec_cursor_scroll_exempt = false;

draw_sprite_ext(phone.spr_pho_cursor, 0, x1, y1, 1, 1, 000, col, codec_cursor_scroll_exempt ? 1 : phone.image_alpha);
draw_sprite_ext(phone.spr_pho_cursor, 0, x1, y2, 1, 1, 090, col, codec_cursor_scroll_exempt ? 1 : phone.image_alpha);
draw_sprite_ext(phone.spr_pho_cursor, 0, x2, y2, 1, 1, 180, col, codec_cursor_scroll_exempt ? 1 : phone.image_alpha);
draw_sprite_ext(phone.spr_pho_cursor, 0, x2, y1, 1, 1, 270, col, codec_cursor_scroll_exempt ? 1 : phone.image_alpha);



if !selected && !prev_selected && !codec_cursor_scroll_exempt{ // Scroll phone main screen
	var top_b = origin_y + 10;
	var bot_b = origin_y + screen_h + 1;
	
	if (y1 < top_b) scroll_y -= y1 - lerp(y1, top_b, 0.5);
	if (y2 > bot_b) scroll_y -= y2 - lerp(y2, bot_b, 0.5);
	
	if scroll_y > 0 scroll_y = 0;
}

codec_cursor_scroll_exempt = false;



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



#define changeCursor(x, y, w, h)

cursor_x = x;
cursor_y = y;
cursor_w = w;
cursor_h = h;



#define maskHeader

gpu_set_blendenable(false);
gpu_set_colorwriteenable(false,false,false,true);
draw_set_alpha(0);
draw_rectangle_color(0,0, room_width, room_height, c_white, c_white, c_white, c_white, false);
if "phone.image_alpha" in self draw_set_alpha(phone.image_alpha);
else draw_set_alpha(1);



#define maskMidder

gpu_set_blendenable(true);
gpu_set_colorwriteenable(true,true,true,true);
gpu_set_blendmode_ext(bm_dest_alpha,bm_inv_dest_alpha);
gpu_set_alphatestenable(true);



#define maskFooter

gpu_set_alphatestenable(false);
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);



#define rectDraw(x1, y1, width, height, color)

draw_rectangle_color(x1, y1, x1 + width, y1 + height, color, color, color, color, false);



#define textDraw(x1, y1, font, color, lineb, linew, align, scale, outline, alpha, text, array_bool)

draw_set_font(asset_get(font));
draw_set_halign(align);

if outline {
    for (i = -1; i < 2; i++) {
        for (j = -1; j < 2; j++) {
            draw_text_ext_transformed_color(x1 + i * 2, y1 + j * 2, text, lineb, linew, scale, scale, 0, c_black, c_black, c_black, c_black, alpha);
        }
    }
}

if alpha draw_text_ext_transformed_color(x1, y1, text, lineb, linew, scale, scale, 0, color, color, color, color, alpha);

if array_bool return [string_width_ext(text, lineb, linew), string_height_ext(text, lineb, linew)];
else return;



















