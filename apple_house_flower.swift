//MARK: - Thrive and Flourish

//1
class ThriveAndFlourish {
	static let shared = ThriveAndFlourish()
	
	private let goal = "Thrive and Flourish"
	
	func setGoals() {
		print("Set goal: \(goal)")
	}
	
	func reflectOnProgress() {
		print("Take a minute to reflect on your progress towards your goal")
	}
	
	func makePlan() {
		print("Write out a plan for how you can reach your goal")
	}
	
	func takeAction() {
		print("Break your plan into smaller steps and take action")
	}
	
	func persist() {
		print("Be persistent and never give up")
	}

}

//2
enum GoalStatus {
	case pending
	case inProgress
	case complete
}

//3
class Goal {
	var name: String
	var status: GoalStatus
	var createdAt: Date
	
	init(name: String, status: GoalStatus, createdAt: Date) {
		self.name = name
		self.status = status
		self.createdAt = createdAt
	}
}

//4
protocol GoalManagerDelegate {
	func goalUpdated(goal: Goal)
	func goalCompleted(goal: Goal)
}

//5
class GoalManager {
	let delegate: GoalManagerDelegate
	
	init(delegate: GoalManagerDelegate) {
		self.delegate = delegate
	}
	
	func updateGoal(withGoal goal: Goal) {
		//update the goal
		self.delegate.goalUpdated(goal: goal)
	}
	
	func completeGoal(withGoal goal: Goal) {
		//complete the goal
		self.delegate.goalCompleted(goal: goal)
	}
}

//6 
struct GoalProgress {
	let goal: Goal
	let currentStep: Int
	let totalSteps: Int
	var progress: Float {
		return Float(currentStep) / Float(totalSteps)
	}
}

//7 
class GoalProgressMonitor {
	let goalManager: GoalManager
	let goalProgress: GoalProgress
	
	init(goalManager: GoalManager, goalProgress: GoalProgress) {
		self.goalManager = goalManager
		self.goalProgress = goalProgress
	}
	
	func checkProgress() {
		if goalProgress.progress == 1.0 {
			goalManager.completeGoal(withGoal: goalProgress.goal)
		}
	}
}

//8
class ThriveFlourishManager: GoalManagerDelegate {
	var goals = [Goal]()
	var goalManager: GoalManager
	
	init(goalManager: GoalManager) {
		self.goalManager = goalManager
	}
	
	func addGoal(withName name: String) {
		goals.append(Goal(name: name, status: .pending, createdAt: Date()))
	}
	
	func goalUpdated(goal: Goal) {
		for (index, existingGoal) in goals.enumerated() {
			if existingGoal.name == goal.name {
				goals[index] = goal
				break
			}
		}
	}
	
	func goalCompleted(goal: Goal) {
		for (index, existingGoal) in goals.enumerated() {
			if existingGoal.name == goal.name {
				goals[index] = goal
				break
			}
		}
	}
}

//9 
class ThriveFlourishViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var goals = [Goal]()
	var goalManager: GoalManager!
	var thriveFlourishManager: ThriveFlourishManager!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		goalManager = GoalManager(delegate: thriveFlourishManager)
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	@IBAction func addGoal(_ sender: Any) {
		let alert = UIAlertController(title: "Add goal", message: nil, preferredStyle: .alert)
		alert.addTextField()
		
		let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
			guard let text = alert.textFields?[0].text,
				let strongSelf = self else { return }
			strongSelf.thriveFlourishManager.addGoal(withName: text)
			strongSelf.tableView.reloadData()
		}
		
		alert.addAction(submitAction)
		present(alert, animated: true)
	}
	
}

//10
extension ThriveFlourishViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return goals.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
		let goal = goals[indexPath.row]
		
		cell.textLabel?.text = goal.name
		
		return cell
	}
}

//11 
extension ThriveFlourishViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let goalProgress = GoalProgress(goal: goals[indexPath.row], currentStep: 0, totalSteps: 10)
		let progressMonitor = GoalProgressMonitor(goalManager: goalManager, goalProgress: goalProgress)
		
		let alert = UIAlertController(title: "Update progress", message: nil, preferredStyle: .actionSheet)
		
		for step in 0..<goalProgress.totalSteps {
			let action = UIAlertAction(title: "\(step + 1)", style: .default) { [weak self] action in
				guard let strongSelf = self else { return }
				
				goalProgress.currentStep = step + 1
				progressMonitor.checkProgress()
				strongSelf.tableView.reloadData()
			}
			alert.addAction(action)
		}
		
		present(alert, animated: true)
	}
}