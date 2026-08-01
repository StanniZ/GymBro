//
//  BuildSessionView.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

struct BuildSessionScrollView: View {
    @ObservedObject var viewModel: BuiltInTemplatesViewModel
    @State private var showCreateTemplate = false

    var body: some View {
        VStack(spacing: 6) {
            headerBuildSession
            filterBar
            scrollSession
        }
        .sheet(isPresented: $showCreateTemplate) {
            CreateTemplateView { template in
                viewModel.saveUserTemplate(template)
                viewModel.selectedFilter = .my
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }

    // MARK: - Header
    private var headerBuildSession: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Build Session")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                Text("Choose a workout:")
                    .font(AppFont.subheadline)
                    .foregroundColor(.weekDay)
            }
            Spacer()
            Button(action: { showCreateTemplate = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                    Image(systemName: "plus")
                        .foregroundColor(.currentday)
                }
            }
        }
    }

    // MARK: - Filter Bar
    private var filterBar: some View {
        HStack(spacing: 0) {
            ForEach(TemplateFilter.allCases, id: \.self) { filter in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedFilter = filter
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(filter.rawValue)
                            .font(AppFont.subheadline)
                            .foregroundColor(viewModel.selectedFilter == filter ? .white : .weekDay)
                        Rectangle()
                            .fill(viewModel.selectedFilter == filter ? Color.currentday : Color.clear)
                            .frame(height: 2)
                            .cornerRadius(1)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Scroll / Empty state
    @ViewBuilder
    private var scrollSession: some View {
        if viewModel.displayedTemplates.isEmpty {
            emptyState
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.displayedTemplates) { session in
                        BuildSessionCard(
                            session: session,
                            onSelect: { viewModel.didSelectTemplate(session) },
                            onDelete: viewModel.selectedFilter == .my
                                ? { viewModel.deleteUserTemplate(with: session.id) }
                                : nil
                        )
                    }
                }
            }
            .cornerRadius(20)
        }
    }

    private var emptyState: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: viewModel.selectedFilter == .my
                      ? "plus.rectangle.on.rectangle"
                      : "clock.arrow.circlepath")
                    .font(.system(size: 28))
                    .foregroundColor(.weekDay)
                Text(viewModel.selectedFilter == .my
                     ? "No custom templates yet"
                     : "No recent sessions")
                    .font(AppFont.subheadline)
                    .foregroundColor(.weekDay)
            }
            .padding(.vertical, 20)
            Spacer()
        }
    }
}


// MARK: - Card

struct BuildSessionCard: View {
    let session: WorkoutTemplateModel
    let onSelect: () -> Void
    var onDelete: (() -> Void)? = nil

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                VStack(alignment: .leading, spacing: 8) {
                    titleSession
                    HStack {
                        countExercice
                        Spacer()
                        durationSession
                    }
                    Spacer()
                    muscleImage
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 220, height: 160)
            .background(Color.backbutton)
            .cornerRadius(20)
        }
        .contextMenu {
            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private var countExercice: some View {
        HStack(spacing: 4) {
            Image(systemName: "dumbbell")
                .foregroundColor(.white)
            Text("\(session.countExercise)")
                .foregroundColor(.currentday)
        }
        .font(AppFont.subheadline)
    }

    private var titleSession: some View {
        Text(session.name)
            .font(AppFont.body)
            .foregroundColor(.white)
            .shadow(color: Color.black, radius: 1.5, x: 0, y: 0)
    }

    private var durationSession: some View {
        HStack(spacing: 4) {
            Image(systemName: "hourglass")
                .foregroundColor(.white)
            (
                Text("\(session.durationMinutes)")
                    .foregroundColor(.currentday)
                + Text(" min")
                    .foregroundColor(.weekDay)
            )
        }
        .font(AppFont.caption)
    }

    private var muscleImage: some View {
        HStack(spacing: 4) {
            ForEach(session.muscleIcons.prefix(4), id: \.self) { muscleIcon in
                Image(muscleIcon)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            }
        }
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.borderbtn, lineWidth: 1)
    }
}
