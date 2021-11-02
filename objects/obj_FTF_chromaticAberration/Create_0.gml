#region inherit

	event_inherited();

#endregion

#region functions

	#region Pass_Uniforms
	
		Pass_Uniforms = function(){												
			shader_set_uniform_f(U_offsetX, offsetX);
			shader_set_uniform_f(U_offsetY, offsetY);
		}
	
	#endregion
	
	#region RunOnUpdate
	
		RunOnUpdate = function(){
			if(!is_auto){
				return;	
			}
			
			/*if(offsetX != 0 || offsetY != 0){
				if(++timeRelease >= timerRelease){
					timeRelease  = 0;
					timerRelease = irandom(release);
					offsetX      = 0;
					offsetY      = 0;
				}
				
			} else {		
				if(++timeAttack >= timerAttack){
					timeAttack  = 0;
					timerAttack = irandom(attack);
					offsetX     = random_range(-intensity, intensity);
					offsetY     = random_range(-intensity, intensity);
				}	
			}*/
		}
	
	#endregion

#endregion

#region declarations
	
	shader       = shd_chromaticAberration;
	offsetX      = 14/384;
	offsetY      = 14/216;
	U_offsetX    = shader_get_uniform(shader, "OffsetX");
	U_offsetY    = shader_get_uniform(shader, "OffsetY");
	
	intensity    = 2;
	
	attack       = 0;
	timerAttack  = irandom(attack);
	timeAttack   = 0;
	
	release      = 0;
	timerRelease = irandom(release);
	timeRelease  = 0;

#endregion