TankCopActionWalk = TankCopActionWalk or class(CopActionWalk)
TankCopActionWalk._walk_anim_velocities = {
	stand = {
		cbt = {
			walk = {
				fwd = 144,
				bwd = 112.85,
				l = 118.53,
				r = 122.48
			},
			run = {
				fwd = 361.5,
				bwd = 357.23,
				l = 287.43,
				r = 318.33
			}
		}
	}
}
TankCopActionWalk._walk_anim_velocities.stand.ntl = TankCopActionWalk._walk_anim_velocities.stand.cbt
TankCopActionWalk._walk_anim_velocities.stand.hos = TankCopActionWalk._walk_anim_velocities.stand.cbt
TankCopActionWalk._walk_anim_velocities.stand.wnd = TankCopActionWalk._walk_anim_velocities.stand.cbt
TankCopActionWalk._walk_anim_velocities.crouch = TankCopActionWalk._walk_anim_velocities.stand
TankCopActionWalk._walk_anim_lengths = {
	stand = {
		cbt = {
			walk = {
				fwd = 34,
				bwd = 40,
				l = 40,
				r = 38
			},
			run = {
				fwd = 20,
				bwd = 21,
				l = 20,
				r = 21
			}
		}
	}
}
do
	local (for generator), (for state), (for control) = pairs(TankCopActionWalk._walk_anim_lengths)
	do
		do break end
		local (for generator), (for state), (for control) = pairs(stances)
		do
			do break end
			local (for generator), (for state), (for control) = pairs(speeds)
			do
				do break end
				local (for generator), (for state), (for control) = pairs(sides)
				do
					do break end
					sides[side] = speed * 0.03333
				end

			end

			(for control) = nil and speed * 0.03333
		end

		(for control) = nil and pairs
	end

	(for control) = nil and pairs
end

(for control) = {
	walk = {
		fwd = 34,
		bwd = 40,
		l = 40,
		r = 38
	},
	run = {
		fwd = 20,
		bwd = 21,
		l = 20,
		r = 21
	}
} and pairs
TankCopActionWalk._walk_anim_lengths.stand.ntl = TankCopActionWalk._walk_anim_lengths.stand.cbt
TankCopActionWalk._walk_anim_lengths.stand.hos = TankCopActionWalk._walk_anim_lengths.stand.cbt
TankCopActionWalk._walk_anim_lengths.stand.wnd = TankCopActionWalk._walk_anim_lengths.stand.cbt
TankCopActionWalk._walk_anim_lengths.crouch = TankCopActionWalk._walk_anim_lengths.stand
