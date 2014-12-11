//
//  UIStoryboardInjector.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 09/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias UIViewControllerInjector = (UIViewController) -> ()
typealias StoryboardIdentifier = String

class UIStoryboardInjector {
    var controllerDependencies = [StoryboardIdentifier: UIViewControllerInjector] ()

    private func injectControllerDependencies(controller: UIViewController, var identifier: String = "") {
        identifier = controller.restorationIdentifier ?? identifier
        controllerDependencies[identifier]?(controller)
        for childController in controller.childViewControllers as [UIViewController] {
            injectControllerDependencies(childController)
        }
    }
}

private var key = Selector("injector")

extension UIStoryboard {
    // adds injector property to the UIStoryboard class
    private var injector: UIStoryboardInjector? {
        get {
            return objc_getAssociatedObject(self, &key) as? UIStoryboardInjector
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

    // for injector to do its work UIStoryboard instance's class should be switched at runtime to InjectableStoryboard using object_setClass
    class func makeInjectableStoryboard(injector: UIStoryboardInjector, name: String = "Main", bundle: NSBundle? = nil) -> UIStoryboard {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        object_setClass(storyboard, InjectableStoryboard.self)
        storyboard.injector = injector
        return storyboard
    }

    // private class to ensure object can be created only via makeInjectableStoryboard function
    private class InjectableStoryboard: UIStoryboard {

        override func instantiateViewControllerWithIdentifier(identifier: String) -> AnyObject! {
            let vc = super.instantiateViewControllerWithIdentifier(identifier) as UIViewController!
            injector?.injectControllerDependencies(vc, identifier: identifier)
            return vc
        }
    }
}

