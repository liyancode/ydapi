module YDAPI
  module BizModel
    module DBModel
      class DAO_OrderContract < Sequel::Model(:order_contract)
        @@logger = BIZ_MODEL_LOGGER

        def DAO_OrderContract.func_add(order_contract)
          begin
            DAO_OrderContract.create do |c|
              c.created_by = order_contract.created_by
              c.last_update_by = order_contract.last_update_by
              c.comment = order_contract.comment
              c.contract_id = order_contract.contract_id
              c.type = order_contract.type

              c.a_customer_id = order_contract.a_customer_id
              c.a_name = order_contract.a_name
              c.a_address = order_contract.a_address
              c.a_tax_qualification = order_contract.a_tax_qualification
              c.a_tax_number = order_contract.a_tax_number
              c.a_bankcard_number = order_contract.a_bankcard_number
              c.a_bankcard_location = order_contract.a_bankcard_location
              c.a_principal_name = order_contract.a_principal_name
              c.a_principal_phone_number = order_contract.a_principal_phone_number
              c.a_principal_email = order_contract.a_principal_email
              c.a_principal_other_contact = order_contract.a_principal_other_contact

              c.b_customer_id = order_contract.b_customer_id
              c.b_name = order_contract.b_name
              c.b_address = order_contract.b_address
              c.b_tax_qualification = order_contract.b_tax_qualification
              c.b_tax_number = order_contract.b_tax_number
              c.b_bankcard_number = order_contract.b_bankcard_number
              c.b_bankcard_location = order_contract.b_bankcard_location
              c.b_principal_name = order_contract.b_principal_name
              c.b_principal_phone_number = order_contract.b_principal_phone_number
              c.b_principal_email = order_contract.b_principal_email
              c.b_principal_other_contact = order_contract.b_principal_other_contact

              c.sign_date = order_contract.sign_date
              c.sign_location = order_contract.sign_location
              c.start_date = order_contract.start_date
              c.end_date = order_contract.end_date
              c.payment_total = order_contract.payment_total
              c.payment_currency = order_contract.payment_currency
              c.payment_type = order_contract.payment_type
              c.payment_paid = order_contract.payment_paid
              c.contract_detail_product_items = order_contract.contract_detail_product_items
              c.contract_detail_content = order_contract.contract_detail_content
              c.contract_status = order_contract.contract_status
              c.review_by = order_contract.review_by
              c.review_status = order_contract.review_status
              c.review_comment = order_contract.review_comment

            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{order_contract}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_delete(contract_id)
          begin
            DAO_OrderContract[contract_id: contract_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{contract_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_update(order_contract)
          begin
            exist_order_contract = DAO_OrderContract[contract_id: order_contract.contract_id]
            new_order_contract = exist_order_contract.update(
                last_update_by: order_contract.last_update_by,
                comment: order_contract.comment,
                type: order_contract.type,

                a_customer_id: order_contract.a_customer_id,
                a_name: order_contract.a_name,
                a_address: order_contract.a_address,
                a_tax_qualification: order_contract.a_tax_qualification,
                a_tax_number: order_contract.a_tax_number,
                a_bankcard_number: order_contract.a_bankcard_number,
                a_bankcard_location: order_contract.a_bankcard_location,
                a_principal_name: order_contract.a_principal_name,
                a_principal_phone_number: order_contract.a_principal_phone_number,
                a_principal_email: order_contract.a_principal_email,
                a_principal_other_contact: order_contract.a_principal_other_contact,

                b_customer_id: order_contract.b_customer_id,
                b_name: order_contract.b_name,
                b_address: order_contract.b_address,
                b_tax_qualification: order_contract.b_tax_qualification,
                b_tax_number: order_contract.b_tax_number,
                b_bankcard_number: order_contract.b_bankcard_number,
                b_bankcard_location: order_contract.b_bankcard_location,
                b_principal_name: order_contract.b_principal_name,
                b_principal_phone_number: order_contract.b_principal_phone_number,
                b_principal_email: order_contract.b_principal_email,
                b_principal_other_contact: order_contract.b_principal_other_contact,

                sign_date: order_contract.sign_date,
                sign_location: order_contract.sign_location,
                start_date: order_contract.start_date,
                end_date: order_contract.end_date,
                payment_total: order_contract.payment_total,
                payment_currency: order_contract.payment_currency,
                payment_type: order_contract.payment_type,
                payment_paid: order_contract.payment_paid,
                contract_detail_product_items: order_contract.contract_detail_product_items,
                contract_detail_content: order_contract.contract_detail_content,
                contract_status: order_contract.contract_status,
                review_by: order_contract.review_by,
                review_status: order_contract.review_status,
                review_comment: order_contract.review_comment
            )
            if new_order_contract
              new_order_contract
            else
              exist_order_contract
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{order_contract.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_get_all_to_one_a_customer(a_customer_id)
          begin
            DAO_OrderContract.dataset.where(a_customer_id: a_customer_id).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_a_customer(#{a_customer_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_get_all_to_one_b_customer(b_customer_id)
          begin
            DAO_OrderContract.dataset.where(b_customer_id: b_customer_id).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_b_customer(#{b_customer_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_get_all_by_review_status(review_status)
          begin
            DAO_OrderContract.dataset.where(review_status: review_status).where(status: 1).order(:last_update_at).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_review_status(#{review_status}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_get_all_by_created_by(created_by)
          begin
            DAO_OrderContract.dataset.where(created_by: created_by).where(status: 1).order(:last_update_at).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_created_by(#{created_by}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_get_by_id(id)
          begin
            DAO_OrderContract[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContract.func_get_by_contract_id(contract_id)
          begin
            DAO_OrderContract[contract_id: contract_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_contract_id(#{contract_id}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end