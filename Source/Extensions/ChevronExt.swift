////
///  ChevronExt.swift
//

func <<(lhs: UIView, rhs: UIView) {
    lhs.addSubview(rhs)
}

func <<(lhs: UIViewController, rhs: UIViewController) {
    lhs.addChildViewController(rhs)
}

func <<(lhs: SKNode, rhs: SKNode) {
    lhs.addChild(rhs)
}

@discardableResult
func << <EC1 : RangeReplaceableCollection, EC2 : Any>(lhs: inout EC1, rhs: EC2) -> EC1
    where EC2 == EC1.Iterator.Element
{
    lhs.append(rhs)
    return lhs
}
