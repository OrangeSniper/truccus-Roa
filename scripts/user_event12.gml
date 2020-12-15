// Muno template - [CORE] css_draw, post_draw

// DO NOT EDIT - Only edit user_event15.gml



if (object_index == oPlayer || object_index == oTestPlayer){
	if phone_arrow_cooldown && !(phone_arrow_cooldown - 1 < 25 && (phone_arrow_cooldown - 1) % 10 >= 5){
		draw_sprite_ext(spr_pho_cooldown_arrow, 0, x - 7, y - char_height - hud_offset - 28, 1, 1, 0, get_player_damage(player) >= 100 ? get_player_hud_color(player) : phone_darkened_player_color, 1);
	}
	exit;
}
 
user_event(15);

shader_end();



// Version

textDraw(x + 220, y + 210, "fName", c_white, 100, 1000, fa_right, 1, false, 0.25, "char ver. " + string(get_char_info(player, INFO_VER_MAJOR)) + "." + string(get_char_info(player, INFO_VER_MINOR)));



// Compatibility

var displayed = [
	pho_has_muno_phone,
	pho_has_trum_codec,
	pho_has_copy_power,
	pho_has_btt_layout,
	
	pho_has_otto_bhead,
	pho_has_steve_dmsg,
	pho_has_feri_taunt,
	pho_has_hikaru_fak,
	pho_has_rat_allout,
	pho_has_tco_sketch,
	pho_has_ahime_dead,
	pho_has_tink_picto,
	pho_has_fire_taunt,
	pho_has_wall_e_ost,
	pho_has_amber_love,
	pho_has_moon_music,
	pho_has_agentn_cdc,
	
	pho_has_drac_codec,
	pho_has_miivs_post,
	pho_has_dede_title,
	pho_has_soul_title,
	pho_has_been_found,
	pho_has_resort_pic,
	pho_has_pkmn_image,
	pho_has_daro_codec
	];

var total = 0;
var long = keyboard_key == 48 || array_length_1d(displayed) < 5;
var len = long ? array_length_1d(displayed) : 4;
// long = false;
for (i = 0; i < len; i++) if displayed[i] total++;

var iters = 0;
var max_col = long ? 6 : 5;
	
for (i = 0; i < len; i++){
	if displayed[i]{
		if long draw_sprite(sprite_get("_pho_compatibility_badges"), i, x + 8 + 18 * floor(i / max_col), y + 40 + 18 * (iters % max_col));
		else draw_sprite(sprite_get("_pho_compatibility_badges"), i, x + 12 + 22 * floor(i / max_col), y + 44 + 22 * (iters % max_col));
		iters++;
	}
}



// Alt costume

var alt_cur = get_player_color(player);

rectDraw(x + 10, y + 10, 201, 5, c_black);
 
for(i = 0; i < num_alts; i++){
    var draw_color = (i == alt_cur) ? c_white : c_gray;
    var draw_x = x + 78 + 8 * i;
    rectDraw(draw_x, y + 10, 5, 3, draw_color);
}

var txt = "#" + string(alt_cur);

rectDraw(x + 76, y + 15, 41, 20, c_black);

textDraw(x + 82, y + 19, "fName", c_white, 20, 1000, fa_left, 1, false, 1, txt);



#define maskHeader

gpu_set_blendenable(false);
gpu_set_colorwriteenable(false,false,false,true);
draw_set_alpha(0);
draw_rectangle_color(0,0, room_width, room_height, c_white, c_white, c_white, c_white, false);
draw_set_alpha(draw_opac);



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



#define textDraw(x1, y1, font, color, lineb, linew, align, scale, outline, alpha, text)

draw_set_font(asset_get(font));
draw_set_halign(align);

if outline{
    for (i = -1; i < 2; i++){
        for (j = -1; j < 2; j++){
            draw_text_ext_transformed_color(x1 + i * 2, y1 + j * 2, text, lineb, linew, scale, scale, 0, c_black, c_black, c_black, c_black, alpha);
        }
    }
}

draw_text_ext_transformed_color(x1, y1, text, lineb, linew, scale, scale, 0, color, color, color, color, alpha);

return [string_width_ext(text, lineb, linew), string_height_ext(text, lineb, linew)];