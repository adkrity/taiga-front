###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

describe "FinalAttachmentsController", ->
    $provide = null
    $controller = null
    mocks = {}

    _mockConfirm = ->
        mocks.confirm = {}

        $provide.value("$tgConfirm", mocks.confirm)

    _mockTranslate = ->
        mocks.translate = {
            instant: sinon.stub()
        }

        $provide.value("$translate", mocks.translate)

    _mockConfig = ->
        mocks.config = {
            get: sinon.stub()
        }

        $provide.value("$tgConfig", mocks.config)

    _mockStorage = ->
        mocks.storage = {
            get: sinon.stub()
        }

        $provide.value("$tgStorage", mocks.storage)

    _mockAttachmetsFullService = ->
        mocks.attachmentsFullService = {}

        $provide.value("tgFinalAttachmentsFullService", mocks.attachmentsFullService)

    _mockProjectService = ->
        mocks.projectService = {
            project: sinon.stub()
            hasPermission: sinon.stub()
        }

        $provide.value("tgProjectService", mocks.projectService)

    _mocks = ->
        module (_$provide_) ->
            $provide = _$provide_

            _mockConfirm()
            _mockTranslate()
            _mockConfig()
            _mockStorage()
            _mockAttachmetsFullService()
            _mockProjectService()

            return null

    _inject = ->
        inject (_$controller_) ->
            $controller = _$controller_

    _setup = ->
        _mocks()
        _inject()

    beforeEach ->
        module "taigaComponents"

        _setup()

    it "toggle deprecated visibility", () ->

        mocks.attachmentsFullService.toggleDeprecatedsVisible = sinon.spy()

        ctrl = $controller("FinalAttachmentsFull")

        ctrl.toggleDeprecatedsVisible()

        expect(mocks.attachmentsFullService.toggleDeprecatedsVisible).to.be.calledOnce

    it "add attachment", () ->
        mocks.attachmentsFullService.addAttachment = sinon.spy()

        ctrl = $controller("FinalAttachmentsFull")

        file = Immutable.Map()

        ctrl.projectId = 3
        ctrl.objId = 30
        ctrl.type = 'us'
        ctrl.mode = 'list'

        ctrl.addAttachment(file)

        expect(mocks.attachmentsFullService.addAttachment).to.have.been.calledWith(3, 30, 'us', file, true)

    it "add attachments", () ->
        ctrl = $controller("FinalAttachmentsFull")

        ctrl.attachments = Immutable.List()
        ctrl.addAttachment = sinon.spy()

        files = [
            {},
            {},
            {}
        ]

        ctrl.addAttachments(files)

        expect(ctrl.addAttachment).to.have.callCount(3)

    describe "deleteattachments", () ->
        it "success attachment", (done) ->
            deleteFile = Immutable.Map()

            mocks.attachmentsFullService.deleteAttachment = sinon.stub()
            mocks.attachmentsFullService.deleteAttachment.withArgs(deleteFile, 'us').promise().resolve()

            askResponse = {
                finish: sinon.spy()
            }

            mocks.translate.instant.withArgs('FINAL_ATTACHMENT.TITLE_LIGHTBOX_DELETE_ATTACHMENT').returns('title')
            mocks.translate.instant.withArgs('FINAL_ATTACHMENT.MSG_LIGHTBOX_DELETE_ATTACHMENT').returns('message')

            mocks.confirm.askOnDelete = sinon.stub()
            mocks.confirm.askOnDelete.withArgs('title', 'message').promise().resolve(askResponse)

            ctrl = $controller("FinalAttachmentsFull")

            ctrl.type = 'us'

            ctrl.deleteAttachment(deleteFile).then () ->
                expect(askResponse.finish).have.been.calledOnce
                done()

        it "error attachment", (done) ->
            deleteFile = Immutable.Map()

            mocks.attachmentsFullService.deleteAttachment = sinon.stub()
            mocks.attachmentsFullService.deleteAttachment.withArgs(deleteFile, 'us').promise().reject(new Error('error'))

            askResponse = {
                finish: sinon.spy()
            }

            mocks.translate.instant.withArgs('FINAL_ATTACHMENT.TITLE_LIGHTBOX_DELETE_ATTACHMENT').returns('title')
            mocks.translate.instant.withArgs('FINAL_ATTACHMENT.MSG_LIGHTBOX_DELETE_ATTACHMENT').returns('message')
            mocks.translate.instant.withArgs('FINAL_ATTACHMENT.ERROR_DELETE_ATTACHMENT').returns('error')

            mocks.confirm.askOnDelete = sinon.stub()
            mocks.confirm.askOnDelete.withArgs('title', 'message').promise().resolve(askResponse)

            mocks.confirm.notify = sinon.spy()

            ctrl = $controller("FinalAttachmentsFull")

            ctrl.type = 'us'

            ctrl.deleteAttachment(deleteFile).then () ->
                expect(askResponse.finish.withArgs(false)).have.been.calledOnce
                expect(mocks.confirm.notify.withArgs('error', null, 'error'))
                done()

    it "loadAttachments", () ->
        mocks.attachmentsFullService.loadAttachments = sinon.spy()

        ctrl = $controller("FinalAttachmentsFull")

        ctrl.projectId = 3
        ctrl.objId = 30
        ctrl.type = 'us'

        ctrl.loadAttachments()

        expect(mocks.attachmentsFullService.loadAttachments).to.have.been.calledWith('us', 30, 3)

    it "reorder attachments", () ->
        mocks.attachmentsFullService.reorderAttachment = sinon.spy()

        ctrl = $controller("FinalAttachmentsFull")

        file = Immutable.Map()

        ctrl.projectId = 3
        ctrl.objId = 30
        ctrl.type = 'us'

        ctrl.reorderAttachment(file, 5)

        expect(mocks.attachmentsFullService.reorderAttachment).to.have.been.calledWith(30, 'us', file, 5)

    it "update attachment", () ->
        mocks.attachmentsFullService.updateAttachment = sinon.spy()

        ctrl = $controller("FinalAttachmentsFull")

        file = Immutable.Map()

        ctrl.type = 'us'

        ctrl.updateAttachment(file, 5)

        expect(mocks.attachmentsFullService.updateAttachment).to.have.been.calledWith(file, 'us')

    it "if attachments editable", () ->
        mocks.projectService.project = true
        ctrl = $controller("FinalAttachmentsFull")

        ctrl._isEditable()

        expect(mocks.projectService.hasPermission).has.been.called

    it "if attachments are not editable", () ->
        mocks.projectService.project = false
        ctrl = $controller("FinalAttachmentsFull")

        expect(ctrl._isEditable()).to.be.false
