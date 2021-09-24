import Rails from '@rails/ujs';
import Swal from 'sweetalert2';

Rails.confirm = (message, element) => {
  const title = element.getAttribute('data-title');
  const cancelBtn = element.getAttribute('data-cancel');
  const commitBtn = element.getAttribute('data-commit');
  const iconType = element.getAttribute('data-icon');


  Swal.fire({
    customClass: {
      confirmButton: 'btn btn-sucess-one mx-1',
      cancelButton: 'btn btn-cancel-one mx-1'
    },
    buttonsStyling: false,

    titleText: title || '',
    text: message || '',
    showCancelButton: true,
    html: '<i class="' + iconType + '" style="color: #f27474; font-size: 100px; block-size: 175px; animation: bounce; animation-duration: 1s;"></i></br>'+ message,
    cancelButtonText: cancelBtn || 'Cancel',
    confirmButtonText: commitBtn || 'Confirm',
    showCloseButton: true
  }).then(result => {
    if(result.isConfirmed) {
      const old = Rails.confirm;
      Rails.confirm = () => true;
      element.click();
      Rails.confirm = old;
    }
  }).catch(error => {
    console.log(error);
  });

  return false;
}
