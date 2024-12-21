###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

FinalAttachmentsSimpleDirective = () ->
    link = (scope, el, attrs, ctrl) ->
        scope.displayAttachmentInput = (event) ->
            angular.element('#add-attach').click();
            return false;

    return {
        scope: {},
        bindToController: {
            attachments: "=",
            onAdd: "&",
            onDelete: "&"
        },
        controller: "FinalAttachmentsSimple",
        controllerAs: "vm",
        templateUrl: "components/final-attachments-simple/final-attachments-simple.html",
        link: link
    }

FinalAttachmentsSimpleDirective.$inject = []

angular.module("taigaComponents").directive("tgFinalAttachmentsSimple", FinalAttachmentsSimpleDirective)
