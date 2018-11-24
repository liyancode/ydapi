module YDAPI
  module BizModel
    class CustomersModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@customer = YDAPI::BizEntity::Customer
      @@customer_contact = YDAPI::BizEntity::CustomerContact

      @@customers = YDAPI::BizModel::DBModel::Customers
      @@customers_contacts = YDAPI::BizModel::DBModel::CustomersContacts

      def CustomersModel.add_new_customer(customer)
        if customer.is_a?(@@customer)
          new_id = @@helper.new_customer_id(@@customers.func_get_max_customer_id)
          if new_id != nil
            customer.customer_id = new_id
            @@logger.info("#{self}.add_new_customer, customer=#{customer}")
            @@customers.func_add(customer)
          else
            @@logger.error("#{self}.add_new_customer, get_max_user_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_customer, user is not a #{@@customer}")
          nil
        end
      end

      def CustomersModel.add_new_customer_contact(customer_contact)
        if customer_contact.is_a?(@@customer_contact)
          @@logger.info("#{self}.add_new_customer_contact, customer_contact=#{customer_contact}")
          @@customers_contacts.func_add(customer_contact)
        else
          @@logger.error("#{self}.add_new_customer_contact, customer_contact is not a #{@@customer_contact}")
          nil
        end
      end

      def CustomersModel.delete_customer_by_customer_id(customer_id)
        @@logger.info("#{self}.delete_customer_by_customer_id(#{customer_id})")
        @@customers.func_delete(customer_id)
      end

      def CustomersModel.delete_customer_contact_by_id(id)
        @@logger.info("#{self}.delete_customer_contact_by_id(#{id})")
        @@customers_contacts.func_delete(id)
      end

      def CustomersModel.update_customer(customer)
        @@logger.info("#{self}.update_customer, customer=#{customer}")
        @@customers.func_update(customer)
      end

      def CustomersModel.update_customer_contact(customer_contact)
        @@logger.info("#{self}.update_customer_contact, customer_contact=#{customer_contact}")
        @@customers_contacts.func_update(customer_contact)
      end

      def CustomersModel.get_customer_and_contacts_by_customer_id(customer_id)
        @@logger.info("#{self}.get_customer_and_contacts_by_customer_id(#{customer_id})")
        customer = @@customers.func_get(customer_id)
        if customer
          contacts = @@customers_contacts.func_get_all_to_one_customer(customer_id)
          contacts_array = []
          if contacts
            contacts.each {|row|
              contacts_array << row.values
            }
          end
          {:customer => customer.values, :contacts => contacts_array}
        else
          nil
        end
      end

      def CustomersModel.get_customers_by_user_name(user_name)
        @@logger.info("#{self}.get_customers_by_user_name(#{user_name})")
        customers = @@customers.func_get_by_added_by_user_name(user_name)
        if customers
          customers_array = []
          customers.each {|row|
            customers_array << row.values
          }
          {:customers => customers_array}
        else
          nil
        end
      end

      def CustomersModel.get_all_customers(user_name)
        @@logger.info("#{self}.get_all_customers(#{user_name})")
        customers = @@customers.func_get_all
        if customers
          customers_array = []
          customers.each {|row|
            customers_array << row.values
          }
          {:customers => customers_array}
        else
          nil
        end
      end

      def CustomersModel.get_customers_by_id_arr(customer_id_arr)
        @@logger.info("#{self}.get_customers_by_id_arr(#{customer_id_arr})")
        customers = @@customers.func_get_by_id_arr(customer_id_arr)
        result={}
        if customers
          customers.each {|row|
            result[row[:customer_id]]=row.values
          }
          result
        else
          nil
        end
      end
    end
  end
end