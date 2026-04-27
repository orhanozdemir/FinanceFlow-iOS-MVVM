//
//  AddBudgetViewModelTests.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 28.04.2026.
//

import Testing
import Foundation
@testable import FinanceFlow

struct AddBudgetViewModelTests {
    
    @Test
    func formIsInvalidWhenLimitIsEmpty() {
        let viewModel = AddBudgetViewModel()
        viewModel.limitText = ""
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test
    func formIsInvalidWhenLimitIsZero() {
        let viewModel = AddBudgetViewModel()
        viewModel.limitText = "0"
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test
    func formIsValidWhenLimitIsPositive() {
        let viewModel = AddBudgetViewModel()
        viewModel.limitText = "3000"
        
        #expect(viewModel.isFormValid == true)
    }
    
    @Test
    func makeBudgetCreatesExpectedBudget() throws {
        let viewModel = AddBudgetViewModel()
        let date = Date()
        
        viewModel.category = .food
        viewModel.limitText = "3000"
        viewModel.monthDate = date
        
        let budget = try viewModel.makeBudget()
        
        #expect(budget.category == .food)
        #expect(budget.monthlyLimit == 3000)
        #expect(Calendar.current.isDate(budget.monthDate, equalTo: date, toGranularity: .month))
    }
    
    @Test
    func hasDuplicateBudgetReturnsTrueForSameCategoryAndMonth() {
        let viewModel = AddBudgetViewModel()
        viewModel.category = .food
        viewModel.monthDate = Date()
        
        let budgets = [
            Budget (
                category: .food,
                monthlyLimit: 3000,
                monthDate: Date().startOfMonth
            )
        ]
        
        #expect(viewModel.hasDuplicateBudget(in: budgets) == true)
    }
    
    @Test
    func hasDuplicateBudgetReturnsFalseForDifferentCategory() {
        let viewModel = AddBudgetViewModel()
        viewModel.category = .food
        viewModel.monthDate = Date()
        
        let budgets = [
            Budget (
                category: .transportation,
                monthlyLimit: 1000,
                monthDate: Date().startOfMonth
            )
        ]
        
        #expect(viewModel.hasDuplicateBudget(in: budgets) == false)
    }
}
