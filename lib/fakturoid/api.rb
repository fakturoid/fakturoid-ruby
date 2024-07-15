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
require_relative "api/webhook"

module Fakturoid
  module Api
    def account
      @account ||= Account.new(self)
    end

    def bank_accounts
      @bank_accounts ||= BankAccount.new(self)
    end

    def events
      @events ||= Event.new(self)
    end

    def expenses
      @expenses ||= Expense.new(self)
    end

    def expense_payments
      @expense_payments ||= ExpensePayment.new(self)
    end

    def generators
      @generators ||= Generator.new(self)
    end

    def inbox_files
      @inbox_files ||= InboxFile.new(self)
    end

    def inventory_items
      @inventory_items ||= InventoryItem.new(self)
    end

    def inventory_moves
      @inventory_moves ||= InventoryMove.new(self)
    end

    def invoices
      @invoices ||= Invoice.new(self)
    end

    def invoice_messages
      @invoice_messages ||= InvoiceMessage.new(self)
    end

    def invoice_payments
      @invoice_payments ||= InvoicePayment.new(self)
    end

    def number_formats
      @number_formats ||= NumberFormat.new(self)
    end

    def recurring_generators
      @recurring_generators ||= RecurringGenerator.new(self)
    end

    def subjects
      @subjects ||= Subject.new(self)
    end

    def todos
      @todos ||= Todo.new(self)
    end

    def users
      @users ||= User.new(self)
    end

    def webhooks
      @webhooks ||= Webhook.new(self)
    end
  end
end
