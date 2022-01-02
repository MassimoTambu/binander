part of dashboard_module;

final dashboardProvider = Provider<DashboardProvider>((ref) {
  return DashboardProvider(ref);
});

class DashboardProvider {
  final Ref ref;

  const DashboardProvider(this.ref);
}
