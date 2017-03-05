/*
 * Insert preview rendering of related content for foreign key fields
 * processed by the PreviewFieldAdminMixin
 */
(function($) {
    $(document).ready(function() {
        var preview_field_inputs = $(":input[data-is-preview-field=true]");

        function insertPreview(field, html) {
            var preview_container = field.parent().find("span.preview-field");
            if (preview_container.length == 0) {
                field.parent().append("<span class='preview-field'></span>");
                preview_container = field.parent().find("span.preview-field");
            }
            preview_container.html(html);
        }

        function fetchPreview(field) {
            var ids = field.val();
            if (!ids) {
                return "";
            }
            // Convoluted process to sanitize list of IDs into 1,2,3 format.
            // In particular this fixes leading, trailing or repeated commas or
            // spaces.
            ids = ids.replace(/[ ,]+/g, " ").trim().split(" ").join(",");

            var url_base = window.location.pathname;
            var url_search = window.location.search;
            var preview_fetch_url = url_base + "preview-field/" + field.attr("name") + "/" + ids + "/";
            if (url_search) {
                preview_fetch_url += url_search;
            }
            $.get(preview_fetch_url
                ).done(function(html_response) {
                    insertPreview(field, html_response);
                }).fail(function(response) {
                    insertPreview(field, "Could not load preview");
                });
        }

        // Attach `change` event handler to previewable fields, and trigger
        // initial change to load preview on initial form load.
        preview_field_inputs.change(function() {
            var field = $(this);
            var html = fetchPreview(field);
            insertPreview(field, html);
        }).change();

        // HACK to override `dismissRelatedLookupPopup()` and
        // `dismissAddAnotherPopup()` in Django's RelatedObjectLookups.js to
        // trigger change event when an ID is selected or added via popup.
        function triggerChangeOnField(win, chosenId) {
            var name = windowname_to_id(win.name);
            var elem = document.getElementById(name);
            $(elem).change();
        }
        window.ORIGINAL_dismissRelatedLookupPopup = window.dismissRelatedLookupPopup
        window.dismissRelatedLookupPopup = function(win, chosenId) {
            ORIGINAL_dismissRelatedLookupPopup(win, chosenId);
            triggerChangeOnField(win, chosenId);
        }
        window.ORIGINAL_dismissAddAnotherPopup = window.dismissAddAnotherPopup
        window.dismissAddAnotherPopup = function(win, chosenId, chosenRepr) {
            ORIGINAL_dismissAddAnotherPopup(win, chosenId, chosenRepr);
            triggerChangeOnField(win, chosenId, chosenRepr);
        }

    });
})(jQuery);
