update employees as a
set levels_pk = ( 
					select 
						pk 
					from levels where level_title = a.level
				);