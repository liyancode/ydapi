module YDAPI
  module BizModel
    module DBModel
      class DAO_Customers < Sequel::Model(:customers)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_Customers.func_add(customer)
          begin
            DAO_Customers.create do |c|
              c.customer_id=customer.customer_id
              c.added_by_user_name=customer.added_by_user_name
              c.company_name=customer.company_name
              c.company_location=customer.company_location
              c.company_tax_number=customer.company_tax_number
              c.company_legal_person=customer.company_legal_person
              c.company_main_business=customer.company_main_business
              c.company_tel_number=customer.company_tel_number
              c.company_email=customer.company_email
              c.company_description=customer.company_description
              c.comment=customer.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{customer}) Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_delete(customer_id)
          begin
            DAO_Customers[customer_id: customer_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{customer_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_update(customer)
          begin
            exist_customer=DAO_Customers[customer_id: customer.customer_id]
            new_customer=exist_customer.update(
                company_location:customer.company_location,
                company_tax_number:customer.company_tax_number,
                company_legal_person:customer.company_legal_person,
                company_main_business:customer.company_main_business,
                company_tel_number:customer.company_tel_number,
                company_email:customer.company_email,
                company_description:customer.company_description,
                comment:customer.comment
            )
            if new_customer
              new_customer
            else
              exist_customer
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{customer}) Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_get(customer_id)
          begin
            DAO_Customers[customer_id: customer_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{customer_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_get_by_added_by_user_name(added_by_user_name)
          begin
            DAO_Customers.dataset.where(added_by_user_name:added_by_user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_added_by_user_name(#{added_by_user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_get_by_id_arr(customer_id_arr)
          begin
            DAO_Customers.dataset.where([[:customer_id,customer_id_arr]]).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id_arr(#{customer_id_arr}) Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_get_all
          begin
            DAO_Customers.dataset.all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all() Exception:#{e}")
            nil
          end
        end

        def DAO_Customers.func_get_max_customer_id
          begin
            DAO_Customers.last.customer_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_customer_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end