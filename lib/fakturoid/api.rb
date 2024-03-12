# frozen_string_literal: true

require_relative "api/base"

# Sorted alphabetically
require_relative "api/account"
require_relative "api/bank_account"
require_relative "api/event"
require_relative "api/expense"
require_relative "api/expense_payment"
require_relative "api/generator"
require_relative "api/inbox_file"
require_relative "api/inventory_item"
require_relative "api/inventory_move"
require_relative "api/invoice"
require_relative "api/invoice_message"
require_relative "api/invoice_payment"
require_relative "api/number_format"
require_relative "api/recurring_generator"
require_relative "api/subject"
require_relative "api/todo"
require_relative "api/user"

module Fakturoid
  module Api
    def account
      @account ||= Account.new(self)
    end

    def bank_account
      @bank_account ||= BankAccount.new(self)
    end

    def event
      @event ||= Event.new(self)
    end

    def expense
      @expense ||= Expense.new(self)
    end

    def expense_payment
      @expense_payment ||= ExpensePayment.new(self)
    end

    def generator
      @generator ||= Generator.new(self)
    end

    def inbox_file
      @inbox_file ||= InboxFile.new(self)
    end

    def inventory_item
      @inventory_item ||= InventoryItem.new(self)
    end

    def inventory_move
      @inventory_move ||= InventoryMove.new(self)
    end

    def invoice
      @invoice ||= Invoice.new(self)
    end

    def invoice_message
      @invoice_message ||= InvoiceMessage.new(self)
    end

    def invoice_payment
      @invoice_payment ||= InvoicePayment.new(self)
    end

    def number_format
      @number_format ||= NumberFormat.new(self)
    end

    def recurring_generator
      @recurring_generator ||= RecurringGenerator.new(self)
    end

    def subject
      @subject ||= Subject.new(self)
    end

    def todo
      @todo ||= Todo.new(self)
    end

    def user
      @user ||= User.new(self)
    end
  end
end
