MediumEditor.prototype.toolbarFormAnchor = function () {
  var anchor = document.createElement('div'),
      input = document.createElement('input'),

      target_label = document.createElement('label'),
      target = document.createElement('input'),

      button_label = document.createElement('label'),
      button = document.createElement('input'),

      asset_button = document.createElement('a');
      asset_icon = document.createElement('i');

      close = document.createElement('a'),
      cancel = document.createElement('a'),
      save = document.createElement('a');

  close.setAttribute('href', '#');
  close.className = 'medium-editor-toobar-anchor-close';
  close.innerHTML = '&times;';

  save.setAttribute('href', '#');
  save.className = 'medium-editor-toobar-anchor-save';
  save.innerHTML = '&#10003;';

  cancel.setAttribute('href', '#');
  cancel.innerHTML = '&times;';
  cancel.setAttribute('title', 'Cancel');
  cancel.setAttribute('data-tooltip', 'true');
  cancel.className = 'medium-editor-cancel';

  input.setAttribute('type', 'text');
  input.className = 'medium-editor-toolbar-anchor-input';
  input.setAttribute('placeholder', this.options.anchorInputPlaceholder);

  target.setAttribute('type', 'checkbox');
  target.className = 'medium-editor-toolbar-anchor-target';
  target_label.setAttribute('title', 'Open in New Window?');
  target_label.setAttribute('data-tooltip', 'true');
  target_label.className = 'medium-editor-toolbar-anchor-target-label';
  // target_label.innerHTML = ' ';
  // target_label.insertBefore(target, target_label.firstChild);

  button.setAttribute('type', 'checkbox');
  button.className = 'medium-editor-toolbar-anchor-button';
  button_label.innerHTML = "Button";
  button_label.insertBefore(button, button_label.firstChild);

  asset_icon.className = 'fa fa-file-pdf-o';
  asset_button.id = 'medium-editor-link-to-asset';
  asset_button.setAttribute('href', '/tenon/item_assets/new?hide_upload=true');
  asset_button.setAttribute('data-modal-remote', 'true');
  asset_button.setAttribute('data-tooltip', 'true');
  asset_button.setAttribute('title', 'Link to an Asset');
  asset_button.setAttribute('data-modal-title', 'Link to Asset');
  asset_button.setAttribute('data-modal-handler', 'Tenon.features.tenonContent.AssetLink');
  asset_button.appendChild(asset_icon);

  anchor.className = 'medium-editor-toolbar-form-anchor';
  anchor.id = 'medium-editor-toolbar-form-anchor';
  anchor.appendChild(input);

  if (this.options.anchorTarget) {
    anchor.appendChild(target);
    anchor.appendChild(target_label);
  }

  anchor.appendChild(asset_button);
  anchor.appendChild(cancel);

  // anchor.appendChild(save);
  // anchor.appendChild(close);

  // if (this.options.anchorButton) {
  //   anchor.appendChild(button_label);
  // }


  return anchor;

  // var anchor = document.createElement('div'),
  //   input = document.createElement('input'),
  //   a = document.createElement('a'),
  //   button = document.createElement('a');
  //   icon = document.createElement('i');
  //   target_label = document.createElement('label'),
  //   target = document.createElement('input'),


  // a.setAttribute('href', '#');
  // a.innerHTML = '&times;';
  // a.className = 'medium-editor-cancel';

  // button.id = 'medium-editor-link-to-asset';
  // button.setAttribute('href', '/tenon/item_assets/new?hide_upload=true');
  // button.setAttribute('data-modal-remote', 'true');
  // button.setAttribute('data-tooltip', 'true');
  // button.setAttribute('title', 'Link to an Asset');
  // button.setAttribute('data-modal-title', 'Link to Asset');
  // button.setAttribute('data-modal-handler', 'Tenon.features.tenonContent.AssetLink');

  // icon.className = 'fa fa-file-pdf-o';

  // button.appendChild(icon);

  // input.setAttribute('type', 'text');
  // input.className = 'medium-editor-toolbar-anchor-input';
  // input.setAttribute('placeholder', this.options.anchorInputPlaceholder);

  // target.setAttribute('type', 'checkbox');
  // target.className = 'medium-editor-toolbar-anchor-target';
  // target_label.innerHTML = "Open in New Window?";
  // target_label.insertBefore(target, target_label.firstChild);

  // anchor.className = 'medium-editor-toolbar-form-anchor';
  // anchor.id = 'medium-editor-toolbar-form-anchor';
  // anchor.appendChild(input);
  // anchor.appendChild(button);
  // anchor.appendChild(a);

  // return anchor;
};

MediumEditor.prototype.bindAnchorForm = function () {
  var linkCancel = this.anchorForm.querySelector('a.medium-editor-cancel'),
      self = this;

  this.anchorForm.addEventListener('click', function (e) {
    if ( !$(e.target).is('#medium-editor-link-to-asset *, #medium-editor-link-to-asset') ) {
      e.stopPropagation();
    }
  });
  this.anchorInput.addEventListener('keyup', function (e) {
    if (e.keyCode === 13) {
        e.preventDefault();
        self.createLink(this);
    }
  });
  this.anchorInput.addEventListener('click', function (e) {
      // make sure not to hide form when cliking into the input
      e.stopPropagation();
      self.keepToolbarAlive = true;
  });
  this.anchorInput.addEventListener('blur', function () {
      // self.keepToolbarAlive = false;
      self.checkSelection();
  });
  linkCancel.addEventListener('click', function (e) {
      e.preventDefault();
      self.showToolbarActions();
      restoreSelection(self.savedSelection);
  });
  return this;
};