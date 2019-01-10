module YDAPI
  module BizModel
    module DBModel
      class DAO_PaymentHistory < Sequel::Model(:payment_history)
        @@logger = BIZ_MODEL_LOGGER

        def DAO_PaymentHistory.func_add(payment_history)
          begin
            DAO_PaymentHistory.create do |c|
              c.created_by = payment_history.created_by
              c.last_update_by = payment_history.last_update_by
              c.comment = payment_history.comment

              c.payment_id = payment_history.payment_id
              c.type = payment_history.type
              c.type_comment = payment_history.type_comment
              c.contract_id = payment_history.contract_id
              c.other_ref_id = payment_history.other_ref_id
              c.payment_method = payment_history.payment_method
              c.payment_payer_id = payment_history.payment_payer_id
              c.payment_beneficiary_id = payment_history.payment_beneficiary_id
              c.payment_currency = payment_history.payment_currency
              c.payment_value = payment_history.payment_value
              c.payment_at = payment_history.payment_at
              c.payment_message = payment_history.payment_message
              c.payment_screenshot = payment_history.payment_screenshot
              c.payment_review_by = payment_history.payment_review_by
              c.payment_review_status = payment_history.payment_review_status
              c.payment_operator = payment_history.payment_operator
              c.payment_status = payment_history.payment_status
              c.other = payment_history.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{payment_history}) Exception:#{e}")
            nil
          end
        end

        def DAO_PaymentHistory.func_delete(id)
          begin
            DAO_PaymentHistory[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_PaymentHistory.func_delete_by_payment_id(payment_id)
          begin
            DAO_PaymentHistory[payment_id: payment_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete_by_payment_id(#{payment_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_PaymentHistory.func_update(payment_history)
          begin
            exist_payment_history = DAO_PaymentHistory[contract_id: payment_history.contract_id]
            new_payment_history = exist_payment_history.update(
                last_update_by: payment_history.last_update_by,
                comment: payment_history.comment,

                type: payment_history.type,
                type_comment: payment_history.type_comment,
                contract_id: payment_history.contract_id,
                other_ref_id: payment_history.other_ref_id,
                payment_method: payment_history.payment_method,
                payment_payer_id: payment_history.payment_payer_id,
                payment_beneficiary_id: payment_history.payment_beneficiary_id,
                payment_currency: payment_history.payment_currency,
                payment_value: payment_history.payment_value,
                payment_at: payment_history.payment_at,
                payment_message: payment_history.payment_message,
                payment_screenshot: payment_history.payment_screenshot,
                payment_review_by: payment_history.payment_review_by,
                payment_review_status: payment_history.payment_review_status,
                payment_operator: payment_history.payment_operator,
                payment_status: payment_history.payment_status,
                other: payment_history.other
            )
            if new_payment_history
              new_payment_history
            else
              exist_payment_history
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{payment_history.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_PaymentHistory.func_get_all_to_one_contract(contract_id)
          begin
            DAO_PaymentHistory.dataset.where(contract_id: contract_id).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_contract(#{contract_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_PaymentHistory.func_get_by_id(id)
          begin
            DAO_PaymentHistory[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_PaymentHistory.func_get_by_payment_id(payment_id)
          begin
            DAO_PaymentHistory[payment_id: payment_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_payment_id(#{payment_id}) Exception:#{e}")
            nil
          end
        end

      end
    end
  end
end