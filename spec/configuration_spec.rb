RSpec.describe Configuration do
  describe '#change_types' do
    subject(:change_types) { described_class.instance.change_types }

    it 'returns the default types' do
      expect(change_types).to eq(%w[defect tech_debt feature])
    end

    context 'with env variable overriting the default' do
      it 'returns the types split over the comma' do
        stub_env('CHANGE_TYPES', 'whatever,is_overwritten')
        expect(change_types).to eq(%w[whatever is_overwritten])
      end
    end
  end
end
