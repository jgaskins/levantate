RSpec.shared_examples 'unacceptable_state_events' do |states, unchanged_attributes|
  states.each do |s|
    context "when #{s}" do
      let(:state) { s.to_sym }

      unchanged_attributes.each do |attr|
        it "should not change #{attr.to_s}" do
          instance_eval "expect { subject }.not_to change { pr.send(#{attr}) }"
        end
      end
    end
  end
end

RSpec.shared_examples 'acceptable_state_events' do |states, changed_attributes, additional_specs|
  states.each do |s|
    context "when #{s}" do
      let(:state) { s }

      changed_attributes.each do |attr|
        it "should change #{attr.to_s}" do
          test = "expect { subject }.to change { pr.send(#{attr}) }"

          if additional_specs.dig(attr, :from)
            test = test + ".from #{additional_specs.dig(attr, :from)}"
          end

          if additional_specs.dig(attr, :to)
            test = test + ".to #{additional_specs.dig(attr, :to)}"
          end

          instance_eval test
        end
      end
    end
  end
end
