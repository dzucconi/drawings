import './application.css';
import Rails from 'rails-ujs';

const init = () => {
  Rails.start();
}

document.addEventListener('DOMContentLoaded', init);
