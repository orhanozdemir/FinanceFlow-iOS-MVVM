//
//  AddTransactionViewModelTests.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation
import Testing
@testable import FinanceFlow

struct AddTransactionViewModelTests {
    
    @Test
    func formIsInvalidWhenTitleIsEmpty() {
        let viewModel = AddTransactionViewModel()
        viewModel.title = ""
        viewModel.amountText = "100"
        viewModel.type = .expense
        viewModel.category = .food
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test
    func formIsInvalidWhenAmountIsNotNumeric() {
        let viewModel = AddTransactionViewModel()
        viewModel.title = "Market"
        viewModel.amountText = "abc"
        viewModel.type = .expense
        viewModel.category = .food
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test
    func formIsInvalidWhenAmountIsZero() {
        let viewModel = AddTransactionViewModel()
        viewModel.title = "Market"
        viewModel.amountText = "0"
        viewModel.type = .expense
        viewModel.category = .food
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test
    func formIsValidWithCorrectInputs() {
        let viewModel = AddTransactionViewModel()
        viewModel.title = "Market"
        viewModel.amountText = "100"
        viewModel.type = .expense
        viewModel.category = .food
        
        #expect(viewModel.isFormValid == true)
    }
    
    @Test
    func makeTransactionCreatesExpectedTransaction() throws {
        let viewModel = AddTransactionViewModel()
        let date = Date()
        
        viewModel.title = "Maaş"
        viewModel.amountText = "15000"
        viewModel.date = date
        viewModel.type = .income
        viewModel.category = .salary
        
        let transaction = try viewModel.makeTransaction()
        
        #expect(transaction.title == "Maaş")
        #expect(transaction.amount == 15000)
        #expect(transaction.date == date)
        #expect(transaction.type == .income)
        #expect(transaction.category == .salary)
    }
    
    @Test
    func makeTransactionThrowsEmptyTitleError() {
        let viewModel = AddTransactionViewModel()
        viewModel.title = ""
        viewModel.amountText = "100"
        viewModel.type = .expense
        viewModel.category = .food
        
        #expect(throws: AddTransactionError.emptyTitle) {
            try viewModel.makeTransaction()
        }
    }
    
    @Test
    func makeTransactionThrowsInvalidAmountError() {
        let viewModel = AddTransactionViewModel()
        viewModel.title = "Market"
        viewModel.amountText = "-10"
        viewModel.type = .expense
        viewModel.category = .food
        
        #expect(throws: AddTransactionError.invalidAmount) {
            try viewModel.makeTransaction()
        }
    }
    
}
