// Muno template - [CORE] set_attack

// DO NOT EDIT - Only edit user_event15.gml



if get_attack_value(attack, AG_MUNO_ATTACK_COOLDOWN) != 0 switch (get_attack_value(attack, AG_MUNO_ATTACK_CD_SPECIAL)){
	case 1:
		move_cooldown[attack] = phone_arrow_cooldown;
		break;
	case 2:
		move_cooldown[attack] = phone_invis_cooldown;
		break;
}



if (attack == AT_TAUNT){
	if (joy_pad_idle && phone_practice){ // phone
		attack = AT_PHONE;
		phone.state = (phone.state == 0) ? 1 : 6;
		phone.state_timer = 0;
	}
}