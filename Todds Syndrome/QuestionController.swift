//
//  QuestionController.swift
//  Todds Syndrome
//
//  Created by Roman on 9/23/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit

class QuestionController: UITableViewController {
    var boolAnswers = ["Yes", "No"]
    let cellId = "cellId"
    let headerId = "headerId"
    
    var questionsList : [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedUser == nil {
            let alertController = UIAlertController.init(title: "Your name?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            let nameAction = UIAlertAction(title: "OK", style: .Default) { (_) in
                let textField = alertController.textFields![0] as UITextField
                if let text = textField.text {
                    selectedUser = User.init()
                    selectedUser?.name = text
                    self.navigationItem.title = text
                }
            }
            nameAction.enabled = false
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Name"
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    nameAction.enabled = textField.text != ""
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            alertController.addAction(nameAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else {
            navigationItem.title = selectedUser?.name
        }
        
        if questionsList.count == 0 {
            questionsList = CoreService.fetchQuestions(selectedUser)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        tableView.registerClass(AnswerCell.self, forCellReuseIdentifier: cellId)
        tableView.registerClass(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source/delegate 
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boolAnswers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! AnswerCell
        
        if let index = getQuestionIndex() {
            let question = questionsList[index]
            cell.nameLabel.text = question.answers[indexPath.row]
            if let positive = question.isPositive {
                cell.accessoryType = positive.integerValue != indexPath.row ? .Checkmark : .None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerId) as! QuestionHeader
        
        if let index = getQuestionIndex() {
            let question = questionsList[index]
            header.nameLabel.text = question.title
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        
        if let index = getQuestionIndex() {
            questionsList[index].isPositive = !Bool(indexPath.item)
            
            if index < questionsList.count - 1 {
                let questionController = QuestionController()
                questionController.questionsList = questionsList
                navigationController?.pushViewController(questionController, animated: true)
            } else {
                let controller = ResultsController()
                controller.questionsList = questionsList
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func getQuestionIndex() -> Int? {
        if var index = navigationController?.viewControllers.indexOf(self) {
            index -= 1
            return index
        }
        return nil
    }
    
}

class ResultsController: UIViewController {
    
    var questionsList :[Question] = []
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "You have 0 percent to have Todd's syndrome"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(ResultsController.done))
        
        navigationItem.title = "Results"
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(resultsLabel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        
        var score = 0
        for question in questionsList {
            if let positive = question.isPositive?.boolValue {
                score += positive == true ? 1 : 0
            }
        }
        resultsLabel.text = "You have \((100/questionsList.count)*score)% to have Todd's syndrome"
    }
    
    func done() {
        if let name = selectedUser?.name {
            CoreService.saveUser(name, questions: questionsList)
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

class QuestionHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.font = UIFont.boldSystemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AnswerCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Answer"
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
}
