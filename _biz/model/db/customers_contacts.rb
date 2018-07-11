module YDAPI
  module BizModel
    module DBModel
      class CustomersContacts < Sequel::Model(:customers_contacts)
        @@logger=BIZ_MODEL_LOGGER
        def CustomersContacts.func_add(customer_contact)
          begin
            CustomersContacts.create do |c|
              c.customer_id=customer_contact.customer_id
              c.added_by_user_name=customer_contact.added_by_user_name
              c.fullname=customer_contact.fullname
              c.gender=customer_contact.gender
              c.title=customer_contact.title
              c.email=customer_contact.email
              c.phone_number=customer_contact.phone_number
              c.other_contact_info=customer_contact.other_contact_info
              c.comment=customer_contact.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{customer_contact}) Exception:#{e}")
            nil
          end
        end

        def CustomersContacts.func_delete(id)
          begin
            CustomersContacts[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{id}) Exception:#{e}")
            nil
          end
        end

        def CustomersContacts.func_update(customer_contact)
          begin
            exist_customer_contact=CustomersContacts[id: customer_contact.id]
            new_customer_contact=exist_customer_contact.update(
                customer_id:customer_contact.customer_id,
                added_by_user_name:customer_contact.added_by_user_name,
                fullname:customer_contact.fullname,
                gender:customer_contact.gender,
                title:customer_contact.title,
                email:customer_contact.email,
                phone_number:customer_contact.phone_number,
                other_contact_info:customer_contact.other_contact_info,
                comment:customer_contact.comment
            )
            if new_customer_contact
              new_customer_contact
            else
              exist_customer_contact
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{customer_contact}) Exception:#{e}")
            nil
          end
        end

        def CustomersContacts.func_get_all_to_one_customer(customer_id)
          begin
            CustomersContacts.dataset.where(customer_id:customer_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_customer(#{customer_id}) Exception:#{e}")
            nil
          end
        end

        def CustomersContacts.func_get_all_by_customer_id_array(customer_id_array)
          begin
            CustomersContacts.dataset.where([[:customer_id,customer_id_array]]).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_customer(#{customer_id_array}) Exception:#{e}")
            nil
          end
        end

        def CustomersContacts.func_get_all_user_name(added_by_user_name)
          begin
            CustomersContacts.dataset.where(added_by_user_name:added_by_user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_customer(#{customer_id}) Exception:#{e}")
            nil
          end
        end

        def CustomersContacts.func_get_by_id(id)
          begin
            CustomersContacts[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end