###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

FinalAttachmentDirective = () ->
    link = (scope, el, attrs, ctrl) ->

    return {
        scope: {},
        bindToController: {
            attachment: "=",
            onDelete: "&",
            onUpdate: "&",
            type: "="
        },
        controller: "FinalAttachment",
        controllerAs: "vm",
        templateUrl: "components/final-attachment/final-attachment.html",
        link: link
    }

FinalAttachmentDirective.$inject = []

angular.module("taigaComponents").directive("tgFinalAttachment", FinalAttachmentDirective)
