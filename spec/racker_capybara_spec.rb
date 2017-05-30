require 'spec_helper'

feature Racker do
  describe 'index page' do
    before {visit '/'}
    
    it 'show index page' do
      expect(page).to have_content('Codebreaker! Make a guess of 4 numbers from 1 to 6.')
    end

    it 'input name' do
      fill_in('name', with: 'Dima')
      click_button('Submit!')
      expect(page).to have_content("Name: 'Dima'")
    end  
  end

  describe 'game page' do
    before {visit '/game'}
    after  {expect(page).to have_current_path('/game')}

    it 'start game' do
      click_button('Submit!')
      expect(page).to have_content('Name:')
    end

    context 'input code' do
      it 'attempts -1' do
        fill_in('code', with: '1111')
        click_button('Submit!')
        expect(page).to have_content("Attempts: '5'")
      end

      it 'chek input' do
        fill_in('code', with: '123456')
        click_button('Submit!')
        expect(page).to have_content("Your answer: '1234'")
      end

      context 'hint' do
        before {click_link('Hint!')}

        it 'shows hint' do
          expect(page).to have_content('Hint:')
        end

        it 'attempts not -1' do
          expect(page).to have_content("Attempts: '6'")
        end
      end

      it 'game_over' do
        6.times do
          fill_in('code', with: '1111')
          click_button('Submit!')
        end
        expect(page).to have_content('Game over! You have no more attempts')
      end
    end
  end

  describe 'end game' do
    before do
      visit '/game'
      6.times do
        fill_in('code', with: '1111')
        click_button('Submit!')
      end
    end

    it 'return index page' do
      click_link('Exit!')
      expect(page).to have_content('Codebreaker! Make a guess of 4 numbers from 1 to 6.')
    end

    it 'open statistics' do
      click_link('Save statistics!')
      expect(File.exist?('./statistics.txt')).to eq(true)
    end

    it 'open statistics' do
      click_link('Open statistics!')
      expect(page).to have_content('Statistics!')
    end
  end

  describe 'statistics' do
    before {visit '/statistics'}

    it 'statistics' do
      expect(page).to have_content('Statistics!')
    end

    it 'return index page' do
      click_link('Exit!')
      expect(page).to have_content('Codebreaker! Make a guess of 4 numbers from 1 to 6.')
    end
  end
  it '404' do
    visit '/sdhd'
    expect(status_code).to be(404)
  end
end