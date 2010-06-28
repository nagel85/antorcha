module TransactionsHelper
  include SwiftHelper
  
  help_can_link_to :transaction

  def link_to_new_transaction_message(transaction)
    if can? :new, Message
      link_to h(t('action.new', :model => Message.human_name)), new_transaction_message_path(transaction), :class => 'message'
    end
  end
  
  def button_to_transaction_cancellation transaction
    if can? :cancel, Transaction
      button_to h(t('action.cancel', :model => Transaction.human_name)), transaction_cancellation_path(transaction), :method => :post, :confirm => 'Are you sure?'
    end
  end
end
