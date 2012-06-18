FactoryGirl.define do
  factory :patient do
    hp_id  "19"  # valid hp_id
  end

  factory :patient_with_invalid_id, :class => :patient do
    hp_id  "123" # invalid hp_id
  end
end
