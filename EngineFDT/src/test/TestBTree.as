package test
{
	import gameui.cell.LabelSource;

	import model.BinaryNode;
	import model.BinaryTree;

	import utils.GDrawUtil;

	import flash.display.Graphics;
	import flash.display.Sprite;




	public class TestBTree extends Sprite {

		private var _tree : BinaryTree;

		private var _target : BinaryNode;

		private function initTree() : void {
			_tree = new BinaryTree();
			_tree.root = new BinaryNode(1);
			_tree.root.left = new BinaryNode(2);
			_tree.root.right = new BinaryNode(3);
			_tree.root.left.left = new BinaryNode(4);
			_tree.root.left.right = new BinaryNode(5);
			_tree.root.right.left = new BinaryNode(6);
			_target = _tree.root.right.left;
			var g : Graphics = graphics;
			g.clear();
			g.beginFill(0xFFFF00, 1);
			GDrawUtil.drawArcTorus(g, 200, 200, 100, 200, 320);
			g.endFill();
		}

		private function testTree() : void {
		}

		public function TestBTree() {
			initTree();
			testTree();
			var lb : LabelSource = new LabelSource("abc", 0);
			trace(lb);
		}
	}
}
