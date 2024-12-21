###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

bindOnce = @.taiga.bindOnce

FinalAttachmentsFullDirective = () ->
    link = (scope, el, attrs, ctrl) ->
        scope.displayAttachmentInput = (event) ->
            angular.element('#add-final-attach').click();
            return false;

    return {
        scope: {},
        bindToController: {
            type: "@",
            objId: "=",
            projectId: "=",
            editPermission: "@"
        },
        controller: "FinalAttachmentsFull",
        controllerAs: "vm",
        templateUrl: "components/final-attachments-full/final-attachments-full.html",
        link: link
    }

FinalAttachmentsFullDirective.$inject = []

angular.module("taigaComponents").directive("tgFinalAttachmentsFull", FinalAttachmentsFullDirective)
