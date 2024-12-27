###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

FinalAttachmentLinkDirective = ($parse, attachmentsPreviewService, lightboxService) ->
    link = (scope, el, attrs) ->
        attachment = $parse(attrs.tgFinalAttachmentLink)(scope)

        el.on "click", (event) ->
            if taiga.isImage(attachment.getIn(['file', 'name']))
                event.preventDefault()

                scope.$apply ->
                    lightboxService.open($('tg-final-attachments-preview'))
                    attachmentsPreviewService.fileId = attachment.getIn(['file', 'id'])
            else if taiga.isPdf(attachment.getIn(['file', 'name']))
                event.preventDefault()
                window.open(attachment.getIn(['file', 'url']))

        scope.$on "$destroy", -> el.off()
    return {
        link: link
    }

FinalAttachmentLinkDirective.$inject = [
    "$parse",
    "tgFinalAttachmentsPreviewService",
    "lightboxService"
]

angular.module("taigaComponents").directive("tgFinalAttachmentLink", FinalAttachmentLinkDirective)
