require 'rails_helper'

RSpec.describe ReleaseFetcher do
  let(:service) { described_class.new }

  describe '#since' do
    # context 'When without time' do
    #   subject(:result) { service.since }

    #   before do
    #     allow_any_instance_of(Series).to receive(:save).and_return(Series.new)
    #     allow_any_instance_of(Group).to receive(:save).and_return(Group.new)
    #   end

    #   it 'get all the releases' do
    #     VCR.use_cassette("releases") do
    #       expect(result.count).to eq 89708
    #     end
    #   end
    # end

    context 'When with time' do
      let(:select_time) { Date.parse('2016/12/24') }
      subject(:result) { service.since(select_time) }

      it 'get releases around that time' do
        VCR.use_cassette("releases") do
          expect(result.count).to eq 720
        end

          expect(result['399281'].slice(:slug, :title, :url, :series, :group)).to eq(
          slug: '399281',
          title: 'c145',
          url: 'http://www.novelupdates.com/extnu/399281/',
          series: Series.find_by(slug: 'lazy-dungeon-master'),
          group: Group.find_by(slug: 'zirus-musings')
        )
        expect(result['399281'][:released_at].to_i).to eq Date.parse('2016/12/27').beginning_of_day.to_i
      end
    end
  end

  describe '#save_since' do
    let(:new_release_attr) { { slug: 'new_slug', title: 'New title', series: create(:series), group: create(:group), released_at: Time.current.beginning_of_day } }
    let(:existing_release_attr) { { slug: 'existing_slug', title: 'Existing title', series: create(:series), group: create(:group), released_at: Time.current.beginning_of_day } }
    let(:release_data) do
      {
        'new_slug' => new_release_attr,
        'existing_slug' => existing_release_attr
      }
    end
    let!(:existing_release) { create(:release, slug: 'existing_slug') }
    let(:new_release) { Release.last }

    before { allow(service).to receive(:since).and_return(release_data) }

    it 'creates new release' do
      expect { service.save_since }.to change { Release.count }.by(1)
      expect(new_release).to have_attributes(new_release_attr)
    end
  end
end

