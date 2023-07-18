//
//  UIMenuActionBuilder.swift
//  YoPoster
//
//  Created by Yi-Chin Hsu on 2023/7/18.
//

import UIKit

class UIMenuActionBuilder {
    
    private var title: String = ""
    private var actions: [Action] = []

    func title(_ title: String) -> UIMenuActionBuilder {
        self.title = title
        return self
    }
    
    func actions(@ActionBuilder _ makeActions: () -> [Action]) -> UIMenuActionBuilder {
        self.actions = makeActions()
        return self
    }
    
    func build() -> UIMenu {
        return UIMenu(
            title: title,
            children: actions.map {
                UIAction(
                    title: $0.title,
                    image: $0.image,
                    handler: $0.action
                )
            }
        )
    }
}

@resultBuilder
struct ActionBuilder {

    typealias Expression = Action
    typealias Component = [Action]

    static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }

    static func buildBlock(_ children: Component...) -> Component {
        return children.flatMap { $0 }
    }
}

struct Action {
    let title: String
    let image: UIImage? = nil
    let action: UIActionHandler
}
