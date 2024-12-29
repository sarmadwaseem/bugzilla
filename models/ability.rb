# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :manage, Project
      can :read, [Engineer, Manager]
      can :create, [Engineer, Manager]
    end

    if user.is_a?(Manager)

      cannot :create, [Admin, Manager, Engineer]
      can :read, Project, id: user.project_ids
      can :manage, Ticket
      can :read, Patch, ticket: { manager_id: user.id }
      can :destroy, Patch
      can :update_status, Patch
    end

    return unless user.is_a?(Engineer)

    can :read, Project, id: user.project_ids
    can :read, Manager
    can :read, Ticket, id: user.ticket_ids
    can :read, Patch
    can :create, Patch # Engineers can create patches for their tickets
    can :update, Patch
    cannot :destroy, Patch
    cannot :update_status, Patch
  end
end
