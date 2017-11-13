//
//  PageVC.swift
//  WeatherGift
//
//  Created by Kaining on 10/16/17.
//  Copyright © 2017 Kaining. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]() //() initialize but nothing in it
    var pageControl: UIPageControl!
    var listBustton: UIButton!
    var aboutButton: UIButton!
    var aboutButtonSize: CGSize!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let newLocation = WeatherLocation(name: "", coordinates: "")
        locationsArray.append(newLocation)
        loadLocations()
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureAboutButton()
        configureListButton()
        configurePageControl()
    }
    
    func loadLocations() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "locationArray") as? Data else {
            print("Could not load locationsArray data from UserDefaults.")
            return
        }
        let decoder = JSONDecoder()
        if let locationsArray = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.locationsArray = locationsArray
        } else {
            print("ERROR: Couldn't decode data read from UserDefaults.")
        }
    }
    
    // MARK:- UI Configuration Methods
    func configurePageControl() {
        let largestWidth = max(barButtonWidth, aboutButton.frame.width)
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (largestWidth * 2)
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: view.frame.height - pageControlHeight, width: pageControlHeight, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
    }
    
    func configureListButton() {
        let barButtonHeight = barButtonWidth
        
        listBustton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        listBustton.setImage(UIImage(named: "listbutton"), for: .normal)
        listBustton.setImage(UIImage(named: "listbutton-highlighted"), for: .highlighted)
        listBustton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listBustton)
    }
    
    func configureAboutButton() {
        let aboutButtonText = "About..."
        let aboutButtonFront = UIFont.systemFont(ofSize: 15)
        let fontAttibutes = [NSAttributedStringKey.font: aboutButtonText]
        aboutButtonSize = aboutButtonText.size(withAttributes: fontAttibutes)
        aboutButtonSize.height += 16
        aboutButtonSize.width += 16
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        aboutButton = UIButton(frame: CGRect(x: 8, y: (safeHeight - 5) - aboutButtonSize.height, width: aboutButtonSize.width, height: aboutButtonSize.height))
        aboutButton.setTitle(aboutButtonText, for: .normal)
        aboutButton.setTitleColor(UIColor.darkText, for: .normal)
        aboutButton.titleLabel?.font = aboutButtonFront
        aboutButton.addTarget(self, action: #selector(segueToAboutVC), for: .touchUpInside)
        view.addSubview(aboutButton)
    }
    
    //MARK:- Segues
    @objc func segueToAboutVC() {
        performSegue(withIdentifier: "ToAboutVC", sender: nil)
    }
    
    @objc func segueToListVC() {
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers![0] as? DetailVC else {return}
        locationsArray = currentViewController.locationsArray
        if segue.identifier == "ToListVC" {
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }
    
    //MARK:- Create View COntroller for UIPageViewController
    func createDetailVC(forPage page: Int) -> DetailVC {
        currentPage = min(max(0, page), locationsArray.count-1)
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
    }
    
}


extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count-1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
    
    @objc func pageControlPressed() {
        guard let currentViewController = self.viewControllers![0] as? DetailVC else {return}
        currentPage = currentViewController.currentPage
        if pageControl.currentPage < currentPage {
            setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
        } else if pageControl.currentPage > currentPage {
            setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
        }
    }
}
