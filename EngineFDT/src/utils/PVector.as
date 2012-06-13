package  utils {

	public class PVector {

		private var _dx : int;

		private var _dy : int;

		private var _length : int;

		private var _angle : int;

		public function PVector(dx : int,dy : int) {
			_dx = dx;
			_dy = dy;
			_length = _dx * _dx + _dy * _dy;
			_angle = Math.round(Math.atan2(_dy, _dx) / Math.PI * 180);
		}
	}
}
