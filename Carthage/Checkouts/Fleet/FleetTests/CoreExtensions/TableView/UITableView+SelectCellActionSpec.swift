import XCTest
import Fleet
import Nimble

@testable import FleetTestApp

class UITableView_SelectCellActionSpec: XCTestCase {
    func test_selectCellAction_whenTheActionExists_performsTheAction() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        Fleet.setAsAppWindowRoot(viewController)

        try! viewController.birdsTableView?.selectCellAction(withTitle: "Two", at: IndexPath(row: 10, section: 0))

        var didPresentAlert = false
        let assertAlertPresentedWithCorrectData: () -> Bool = {
            if didPresentAlert {
                let alert = Fleet.getApplicationScreen()?.topmostViewController as? UIAlertController
                return alert?.message == "Two tapped at row 10"
            }

            let presentedAlert = Fleet.getApplicationScreen()?.topmostViewController as? UIAlertController
            didPresentAlert = presentedAlert != nil
            return false
        }

        expect(assertAlertPresentedWithCorrectData()).toEventually(beTrue())
    }

    func test_selectCellAction_whenTheActionExists_callsWillBeginEditingOnDelegate() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view

        try! viewController.birdsTableView?.selectCellAction(withTitle: "Two", at: IndexPath(row: 10, section: 0))
        expect(viewController.willBeginEditingRowCallArgs.count).to(equal(1))
        expect(viewController.willBeginEditingRowCallArgs.first).to(equal(IndexPath(row: 10, section: 0)))
    }

    func test_selectCellAction_whenTheActionExists_callsDidEndEditingOnDelegate() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view

        try! viewController.birdsTableView?.selectCellAction(withTitle: "Two", at: IndexPath(row: 10, section: 0))
        expect(viewController.didEndEditingRowCallArgs.count).to(equal(1))
        expect(viewController.didEndEditingRowCallArgs.first).to(equal(IndexPath(row: 10, section: 0)))
    }

    func test_selectCellAction_whenTheActionDoesNotExist_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view

        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "Four", at: IndexPath(row: 10, section: 0)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Could not find edit action with title 'Four' at row 10 in section 0.", userInfo: nil, closure: nil)
        )
    }

    func test_selectCellAction_whenNoCellExistsAtThatIndexPath_whenInvalidSectionInIndexPath_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view

        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "One", at: IndexPath(row: 1, section: 1)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Table view has no section 1.", userInfo: nil, closure: nil)
        )
    }

    func test_selectCellAction_whenNoCellExistsAtThatIndexPath_whenInvalidRowInIndexPath_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view

        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "One", at: IndexPath(row: 100, section: 0)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Table view has no row 100 in section 0.", userInfo: nil, closure: nil)
        )
    }

    func test_selectCellAction_whenDataSourceSaysThatIndexPathCannotBeEdited_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view

        // The fourth row in the table view is not editable
        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "One", at: IndexPath(row: 3, section: 0)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Interaction with row 3 in section 0 rejected: Table view data source does not allow editing of that row.", userInfo: nil, closure: nil)
        )
    }

    func test_selectCellAction_whenTableViewDoesNotHaveDataSource_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view
        viewController.birdsTableView?.dataSource = nil

        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "Two", at: IndexPath(row: 10, section: 0)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Data source required to select cell action.", userInfo: nil, closure: nil)
        )
    }

    func test_selectCellAction_whenNoDelegateSet_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view
        viewController.birdsTableView?.delegate = nil

        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "Two", at: IndexPath(row: 10, section: 0)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Delegate required to select cell action.", userInfo: nil, closure: nil)
        )
    }

    func test_selectCellAction_whenDelegateDoesNotImplementEditActionsMethod_raisesException() {
        let storyboard = UIStoryboard(name: "Birds", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BirdsViewController") as! BirdsViewController
        let _ = viewController.view


        class MinimalDelegate: NSObject, UITableViewDelegate {}

        let minimalDelegate = MinimalDelegate()
        viewController.birdsTableView?.delegate = minimalDelegate

        expect { try viewController.birdsTableView?.selectCellAction(withTitle: "Two", at: IndexPath(row: 10, section: 0)) }.to(
            raiseException(named: "Fleet.TableViewError", reason: "Delegate must implement UITableViewDelegate.tableView(_:editActionsForRowAt:) to select cell action.", userInfo: nil, closure: nil)
        )
    }
}
